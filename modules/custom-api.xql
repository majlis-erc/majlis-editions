xquery version "3.1";

module namespace api="http://teipublisher.com/api/custom";

declare namespace tei="http://www.tei-c.org/ns/1.0";

import module namespace nav="http://www.tei-c.org/tei-simple/navigation/tei" at "navigation-tei.xql";
import module namespace pm-config="http://www.tei-c.org/tei-simple/pm-config" at "pm-config.xql";
import module namespace rutil="http://e-editiones.org/roaster/util"  at "/db/system/repo/roaster-1.11.0/content/util.xql";
import module namespace errors="http://e-editiones.org/roaster/errors" at "/db/system/repo/roaster-1.11.0/content/errors.xql";
import module namespace app="teipublisher.com/app" at "app.xql";
import module namespace config="http://www.tei-c.org/tei-simple/config" at "config.xqm";
import module namespace tpu="http://www.tei-c.org/tei-publisher/util" at "lib/util.xql";

(:~
 : Keep this. This function does the actual lookup in the imported modules.
 :)
declare function api:lookup($name as xs:string, $arity as xs:integer) {
    try {
        function-lookup(xs:QName($name), $arity)
    } catch * {
        ()
    }
};

(:~
 : Custom TOC for editions - only shows structure from main text
 :)
declare function api:edition-toc($request as map(*)) {
    let $doc := xmldb:decode-uri($request?parameters?doc)
    let $target := ($request?parameters?target, "transcription")[1]
    let $icons := $request?parameters?icons
    let $xml := config:get-document($doc)
    
    return
        if (exists($xml)) then
            let $root := ($xml//tei:div[starts-with(@type, 'main-')])[1]
            let $config := tpu:parse-pi(root($xml), ())
            let $model := map { "config": $config }
            return api:toc-div($root, $model, $target, $icons)
        else
            error($errors:NOT_FOUND, "Document " || $doc || " not found")
};

(:~
 : Build TOC recursively - adapted from pages:toc-div
 : Only processes divs, generates pb-link elements for channel navigation
 :)
declare function api:toc-div($node as element()?, $model as map(*), $target as xs:string?, $icons as xs:boolean?) {
    let $view := ($model?config?view, "page")[1]
    let $divs := $node/tei:div
    return
        if (exists($divs)) then
            <ul class="toc edition-toc">
            {
                for $div in $divs
                let $heading := ($div/tei:head[1]/string(), concat("§", $div/@n))[normalize-space(.) != ""][1]
                let $root := (
                    if ($view = "page") then
                        ($div/*[1][self::tei:pb], $div/preceding::tei:pb[1])[1]
                    else
                        (),
                    $div
                )[1]
                let $nodeId := util:node-id($root)
                let $xmlId := $root/@xml:id
                let $hasDivs := exists($div/tei:div)
                return
                    <li>
                    {
                        if ($hasDivs) then
                            <pb-collapse>
                                {
                                    if (not($icons)) then
                                        attribute no-icons { "no-icons" }
                                    else
                                        ()
                                }
                                <span slot="collapse-trigger">
                                {
                                    if ($xmlId) then
                                        <pb-link xml-id="{$xmlId}" node-id="{$nodeId}" emit="{$target}" subscribe="{$target}">{$heading}</pb-link>
                                    else
                                        <pb-link node-id="{$nodeId}" emit="{$target}" subscribe="{$target}">{$heading}</pb-link>
                                }
                                </span>
                                <span slot="collapse-content">
                                { api:toc-div($div, $model, $target, $icons) }
                                </span>
                            </pb-collapse>
                        else if ($xmlId) then
                            <pb-link xml-id="{$xmlId}" node-id="{$nodeId}" emit="{$target}" subscribe="{$target}">{$heading}</pb-link>
                        else
                            <pb-link node-id="{$nodeId}" emit="{$target}" subscribe="{$target}">{$heading}</pb-link>
                    }
                    </li>
            }
            </ul>
        else
            ()
};

(:~
 : Return all page break facs IDs from the original Judeo-Arabic text
 :)
(:~
 : Return all page break facs IDs from the main text (div[@type starts with 'main-'])
 :)
declare function api:edition-sections($request as map(*)) {
    let $doc := xmldb:decode-uri($request?parameters?doc)
    let $xml := config:get-document($doc)
    
    return
        if (exists($xml)) then
            let $mainDiv := ($xml//tei:div[starts-with(@type, 'main-')])[1]
            let $pbs := $mainDiv//tei:pb
            return array {
                for $pb in $pbs
                let $facs := replace($pb/@facs, '^#', '')
                return $facs
            }
        else
            error($errors:NOT_FOUND, "Document " || $doc || " not found")
};


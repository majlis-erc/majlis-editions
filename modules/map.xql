(:~
 : Implements a mechanism to replace a fragment shown by `pb-view` with another, aligned fragment, e.g. the translation
 : corresponding to a page of the transcription. The local name of a function in this module can be passed to the
 : `map` property of the `pb-view`.
 :)
module namespace mapping="http://www.tei-c.org/tei-simple/components/map";

import module namespace nav="http://www.tei-c.org/tei-simple/navigation/tei" at "navigation-tei.xql";

declare namespace tei="http://www.tei-c.org/ns/1.0";

(:~  
 : Mapping for MAJLIS parallel editions
 : Transforms ID prefix from source version to target version
 : e.g., arHebr_0A → fr_0A, arHebr_ch1 → he_ch1
 : 
 : Usage in pb-view:
 :   map="majlis-parallel" 
 :   <pb-param name="source-prefix" value="arHebr"/>
 :   <pb-param name="target-prefix" value="fr"/>
 :)

(:~  
 : Mapping for parallel text views (translations, transliterations)
 : Transforms ID prefix from main text to target version
 :)
declare function mapping:majlis-parallel($root as element(), $userParams as map(*)) {
    let $targetPrefix := $userParams?target-prefix
    let $targetDiv := (root($root)//tei:div[@xml:id = $targetPrefix])[1]
    let $mainDiv := (root($root)//tei:div[starts-with(@type, 'main-')])[1]

    (: Case 1: $root is a surface (id resolved to facsimile) — find the main pb that references it :)
    let $sourcePb :=
        if (local-name($root) = 'surface') then
            ($mainDiv//tei:pb[@facs = '#' || $root/@xml:id])[1]
        else if (local-name($root) = 'pb') then
            $root
        else ()

    return
        if ($sourcePb) then
            (: page-aligned editions: match target pb by same facs :)
            let $facs := string($sourcePb/@facs)
            let $targetPb := ($targetDiv//tei:pb[@facs = $facs])[1]
            return ($targetPb, ($targetDiv//tei:pb)[1], $targetDiv)[1]
        else
            (: section-aligned editions (Muḥtawī): prefix swap :)
            let $sourcePrefix := string($mainDiv/@xml:id)
            let $sourceId := string((
                $root/ancestor-or-self::*[@xml:id][starts-with(@xml:id, $sourcePrefix || '_')][1]
            )/@xml:id)
            let $targetId :=
                if (starts-with($sourceId, $sourcePrefix || '_')) then
                    $targetPrefix || '_' || substring-after($sourceId, $sourcePrefix || '_')
                else ()
            let $targetNode := if ($targetId != '') then root($root)/id($targetId) else ()
            return
                if ($targetNode) then
                    (($targetNode/descendant::tei:pb)[1], ($targetNode/preceding::tei:pb)[last()], $targetNode)[1]
                else
                    (($targetDiv//tei:pb)[1], $targetDiv)[1]
};

(:~
 : Mapping function for the Konversationslexikon: locate the entry to display
 : by looking up the lemma specified in the search parameter.
 :)
declare function mapping:encyclopedia($root as element(), $userParams as map(*)) {
    let $search := request:get-parameter("search", ())
    return
        if (empty($search)) then
            <p xmlns="http://www.tei-c.org/ns/1.0">No query specified</p>
        else
            let $search := xmldb:decode($search)
            let $byId := id($search, root($root))
            return
                if ($byId) then
                    $byId
                else
                    root($root)//tei:entry[tei:form/tei:term=$search]
};

(:~
 : For the Van Gogh letters: find the page break in the translation corresponding
 : to the one shown in the transcription.
 :)
declare function mapping:vg-translation($root as element(), $userParams as map(*)) {
    let $id := ``[pb-trans-`{$root/@f}`-`{$root/@n}`]``
    let $node := root($root)/id($id)
    return
        $node
};

declare function mapping:cortez-translation($root as element(), $userParams as map(*)) {
    let $first := (($root/following-sibling::text()/ancestor::*[@xml:id])[last()], $root/following-sibling::*[@xml:id], ($root/ancestor::*[@xml:id])[last()])[1]
    let $last := $root/following::tei:pb[1]
    let $firstExcluded := ($last/following-sibling::*[@xml:id], $last/following::*[@xml:id])[1]

    let $mappedStart := root($root)/id(translate($first/@xml:id, "s", "t"))
    let $mappedEnd := root($root)/id(translate($firstExcluded/@xml:id, "s", "t"))
    let $context := root($root)//tei:text[@type='translation']

    return
        nav:milestone-chunk($mappedStart, $mappedEnd, $context)
};

(:~  mapping by retrieving same book number in the translation; assumes div view  ~:)
declare function mapping:barum-book($root as element(), $userParams as map(*)) {
        let $bookNumber := $root/@n
        let $node := root($root)//tei:text[@type='translation']//tei:div[@type="book"][@n=$bookNumber]

    return
        $node
};

(:~  mapping by translating id prefix, by default from prefix s to t1  ~:)
declare function mapping:prefix-translation($root as element(), $userParams as map(*)) {
    let $sourcePrefix := ($userParams?sourcePrefix, 's')[1]
    let $targetPrefix := ($userParams?targetPrefix, 't1')[1]
   
    let $id := $root/@xml:id
    
    let $node := root($root)/id(translate($id, $sourcePrefix, $targetPrefix))

    return
        $node
};

(:~  mapping trying to find a node in the same relation to the base of translation as current node to the base of transcription  ~:)
declare function mapping:offset-translation($root as element(), $userParams as map(*)) {
    
let $language := ($userParams?language, 'en')[1]

let $node-id := util:node-id($root)

let $source-root := util:node-id(root($root)//tei:text[@type='source']/tei:body)
let $translation-root := util:node-id(root($root)//tei:text[@type='translation'][@xml:lang=$language]/tei:body)

let $offset := substring-after($node-id, $source-root)

let $node := util:node-by-id(root($root), $translation-root || $offset) 

return 
    $node

};


(:~  
 : Mapping for the main text view
 : Handles both section IDs and surface IDs (surf-pb-*)
 :)
declare function mapping:majlis-original($root as element(), $userParams as map(*)) {
    let $mainDiv := (root($root)//tei:div[starts-with(@type, 'main-')])[1]
    return
        if (local-name($root) = 'surface') then
            ($mainDiv//tei:pb[@facs = '#' || $root/@xml:id])[1]
        else if (local-name($root) = 'pb') then
            $root
        else
            (($root/descendant::tei:pb)[1], ($root/preceding::tei:pb)[last()], $root)[1]
};

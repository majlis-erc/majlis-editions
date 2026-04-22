
xquery version "3.1";

module namespace pm-config="http://www.tei-c.org/tei-simple/pm-config";

import module namespace pm-editions-web="http://www.tei-c.org/pm/models/editions/web/module" at "../transform/editions-web-module.xql";
import module namespace pm-editions-print="http://www.tei-c.org/pm/models/editions/print/module" at "../transform/editions-print-module.xql";
import module namespace pm-editions-latex="http://www.tei-c.org/pm/models/editions/latex/module" at "../transform/editions-latex-module.xql";
import module namespace pm-editions-epub="http://www.tei-c.org/pm/models/editions/epub/module" at "../transform/editions-epub-module.xql";
import module namespace pm-editions-fo="http://www.tei-c.org/pm/models/editions/fo/module" at "../transform/editions-fo-module.xql";
import module namespace pm-docx-tei="http://www.tei-c.org/pm/models/docx/tei/module" at "../transform/docx-tei-module.xql";

declare variable $pm-config:web-transform := function($xml as node()*, $parameters as map(*)?, $odd as xs:string?) {
    switch ($odd)
    case "editions.odd" return pm-editions-web:transform($xml, $parameters)
    default return pm-editions-web:transform($xml, $parameters)
            
    
};
            


declare variable $pm-config:print-transform := function($xml as node()*, $parameters as map(*)?, $odd as xs:string?) {
    switch ($odd)
    case "editions.odd" return pm-editions-print:transform($xml, $parameters)
    default return pm-editions-print:transform($xml, $parameters)
            
    
};
            


declare variable $pm-config:latex-transform := function($xml as node()*, $parameters as map(*)?, $odd as xs:string?) {
    switch ($odd)
    case "editions.odd" return pm-editions-latex:transform($xml, $parameters)
    default return pm-editions-latex:transform($xml, $parameters)
            
    
};
            


declare variable $pm-config:epub-transform := function($xml as node()*, $parameters as map(*)?, $odd as xs:string?) {
    switch ($odd)
    case "editions.odd" return pm-editions-epub:transform($xml, $parameters)
    default return pm-editions-epub:transform($xml, $parameters)
            
    
};
            


declare variable $pm-config:fo-transform := function($xml as node()*, $parameters as map(*)?, $odd as xs:string?) {
    switch ($odd)
    case "editions.odd" return pm-editions-fo:transform($xml, $parameters)
    default return pm-editions-fo:transform($xml, $parameters)
            
    
};
            


declare variable $pm-config:tei-transform := function($xml as node()*, $parameters as map(*)?, $odd as xs:string?) {
    switch ($odd)
    case "docx.odd" return pm-docx-tei:transform($xml, $parameters)
    default return error(QName("http://www.tei-c.org/tei-simple/pm-config", "error"), "No default ODD found for output mode tei")
            
    
};
            
    
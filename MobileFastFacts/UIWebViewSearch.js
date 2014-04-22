var uiWebview_SearchResultCount = 0;

/*!
 @method     uiWebview_HighlightAllOccurencesOfStringForElement
 @abstract   // helper function, recursively searches in elements and their child nodes
 @discussion // helper function, recursively searches in elements and their child nodes
 
 element    - HTML elements
 keyword    - string to search
 
 //  Created by Scott Kohlert on 11-10-08.
 //  Copyright (c) 2011 The Creation Station. All rights reserved.

 */

function uiWebview_HighlightAllOccurencesOfStringForElement(element,keyword) {
    
    if (element) {
        if (element.nodeType == 3) {        // Text node
            while (true) {
                //if (counter < 1) {
                var value = element.nodeValue;  // Search for keyword in text node
                var idx = value.toLowerCase().indexOf(keyword);
                
                if (idx < 0) break;             // not found, abort
                
                //(value.split);
                
                //we create a SPAN element for every parts of matched keywords
                var span = document.createElement("span");
                var text = document.createTextNode(value.substr(idx,keyword.length));
                span.appendChild(text);
                
                span.setAttribute("class","uiWebviewHighlight");
                span.style.backgroundColor="yellow";
                span.style.color="black";
                
                uiWebview_SearchResultCount++;    // update the counter
                
                text = document.createTextNode(value.substr(idx+keyword.length));
                element.deleteData(idx, value.length - idx);
                var next = element.nextSibling;
                element.parentNode.insertBefore(span, next);
                element.parentNode.insertBefore(text, next);
                element = text;
                
            }
        } else if (element.nodeType == 1) { // Element node
            if (element.style.display != "none" && element.nodeName.toLowerCase() != 'select') {
                for (var i=element.childNodes.length-1; i>=0; i--) {
                    uiWebview_HighlightAllOccurencesOfStringForElement(element.childNodes[i],keyword);
                }
            }
        }
    }
}

// the main entry point to start the search
function uiWebview_HighlightAllOccurencesOfString(keyword) {
    uiWebview_HighlightAllOccurencesOfStringForElement(document.body, keyword.toLowerCase());
}
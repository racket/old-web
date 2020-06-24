(function(){
/*
 * This is my hacked version of
 *   http://www.google.com/afsonline/show_afs_search.js
 * The main things is that if it sees a `cxq' field in the original arguments,
 * it will append it to the `q' field that is sent to Google, but it is not
 * inserted as text in the query field of the search box
 */

var p,n,j;

function r(b,c,o,k) {
  var d = {}, g = b.split(o);
  for (var e = 0; e < g.length; e++) {
    var h = g[e], l = h.indexOf(c);
    if (l > 0) {
      var m = h.substring(0,l);
      if (k) { m = m.toUpperCase(); } else { m = m.toLowerCase(); }
      var v = h.substring(l+1,h.length);
      d[m] = v;
    }
  }
  return d;
}

function w() {
  var b = document.location.search;
  if (b.length < 1) { return ""; }
  b = b.substring(1, b.length);
  var c = r(b, "=", "&", false);
  if (window.googleSearchQueryString != "q"
      && c[window.googleSearchQueryString]) {
    c["q"] = c[window.googleSearchQueryString];
    delete c[window.googleSearchQueryString];
  }
  if (c.cof) {
    var o = r(decodeURIComponent(c.cof), ":", ";", true),
        k = o.FORID;
    if (k) { p = parseInt(k,10); }
  }
  var d = document.getElementById(window.googleSearchFormName);
  if (d) {
    if (d["q"] && c["q"]) {
      d["q"].value = decodeURIComponent(c["q"].replace(/\+/g, " "));
    }
    if (d["sitesearch"]) {
      ss = d["sitesearch"];
      attr = c["sitesearch"];
      for (var g = 0; g < ss.length; g++) {
        ss[g].checked =
          (attr == null && ss[g].value == "") || ss[g].value == attr;
      }
    }
  }
  if (d && d["hq"] && c["hq"]) { d["hq"].value = decodeURIComponent(c["hq"]); }
  if (c["cxq"]) {
    if (d && d["cxq"]) { d["cxq"].value = decodeURIComponent(c["cxq"]); }
    c["q"] += "+" + c["cxq"];
    delete c["cxq"];
  }
  var e = "";
  for (var h in c) { e += "&" + h + "=" + c[h]; }
  return e.substring(1, e.length);
}

function url_param(b,c) {
  if (c) {
    return "&" + b + "=" + encodeURIComponent(c);
  } else {
    return "";
  }
}

function get_search_url() {
  if (window.googleSearchQueryString) {
    window.googleSearchQueryString
      = window.googleSearchQueryString.toLowerCase();
  }
  return "http://"
    + (window.googleSearchDomain || "www.google.com")
    + (window.googleSearchPath   || "/custom")
    + "?"
    + w()
    + url_param("ad", "w"+n)
    + url_param("num", j)
    + url_param("adtest", window.googleAdtest);
}

function u() {
  n = window.googleSearchNumAds || 9;
  j = Math.min(window.googleNumSearchResults || 10, 20);
  var b = {};
  b[9] = 795;
  b[10] = 795;
  b[11] = 500;
  var c = {};
  c[9] = 300+90*j;
  c[10] = 300+50*Math.min(n,4)+90*j;
  c[11] = 300+50*n+90*j;
  var url = get_search_url();
  if (!window.googleSearchFrameborder) {
    window.googleSearchFrameborder="0";
  }
  var anchor = document.getElementById(window.googleSearchIframeName);
  if (anchor && b[p]) {
    var frame = document.createElement("iframe"),
        h = {name         : "googleSearchFrame",
             src          : url,
             frameBorder  : window.googleSearchFrameborder,
             width        : (window.googleSearchFrameWidth || b[p]),
             height       : (window.googleSearchFrameHeight || c[p]),
             marginWidth  : "0",
             marginHeight : "0",
             hspace       : "0",
             vspace       : "0",
             allowTransparency:"true",
             scrolling    : "no"};
    for (var l in h) { frame.setAttribute(l, h[l]); }
    anchor.appendChild(frame);
    if (frame.attachEvent) {
      frame.attachEvent("onload", function(m) { window.scrollTo(0,0); });
    } else {
      frame.addEventListener("load", function(){ window.scrollTo(0,0); },
                             false);
    }
  }
  window.googleSearchIframeName  = null;
  window.googleSearchFormName    = null;
  window.googleSearchQueryString = null;
  window.googleSearchDomain      = null;
  window.googleSearchPath        = null;
  window.googleSearchFrameborder = null;
  window.googleSearchFrameWidth  = null;
  window.googleSearchFrameHeight = null;
  window.googleSearchNumAds      = null;
  window.googleNumSearchResults  = null;
  window.googleAdtest            = null;
}

u();

})()

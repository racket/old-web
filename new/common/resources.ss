#lang at-exp s-exp "../code/main.ss"

;; These are some resources that are shared across different toplevel
;; sites.  They could be included from a single place, but then when
;; one machine crashes the rest won't work right.

(require "layout.ss" "utils.ss")

(define/provide (make-page-resources)
  (list (make-style) (make-logo) (make-icon)))

(define (make-logo)
  (copyfile (in-here "logo.png") "logo.png"))

(define (make-icon)
  (copyfile (in-here "plticon.ico") "plticon.ico"))

(define (make-style)
  @plain[#:id 'plt #:suffix "css"
         #:referrer (lambda (url) (link rel: "stylesheet" type: "text/css"
                                        href: url title: "default"))]{
    html {
      overflow-y: scroll;
    }
    @;
    body {
      color: black;
      background-color: white;
      font-family: Optima, Arial, Verdana, Helvetica, sans-serif;
      margin: 0px;
      padding: 0px;
    }
    @;
    .content {
      margin-left: auto;
      margin-right: auto;
      width: 45em;
    }
    @;
    .navbar {
      background-color: #080;
      color: #ffefd5;
      margin-bottom: 1em;
      padding: 0.5em 0em;
      white-space: nowrap;
    }
    .navbar a {
      color: #ffefd5;
      text-decoration: none;
    }
    @;
    .obstitle {
    }
    .navtitle {
      vertical-align: middle;
      font-size: xx-large;
      font-weight: bold;
    }
    .obsolete {
      vertical-align: middle;
      text-align: left;
      width: 30em;
      display: inline-block;
      background-color: #cfc;
      color: black;
      font-size: small;
      white-space: normal;
      padding: 3px;
      margin-left: 1em;
    }
    .obsolete a {
      color: blue;
      text-decoration: underline;
    }
    .obsother {
      color: red;
      font-weight: bold;
    }
    .obsdimmer {
      position: fixed; z-index: 100;
      width: 100%; height: 100%;
      background-color: #ccc;
      opacity: 0.75; -moz-opacity: 0.75; filter: alpha(opacity=75);
      top: 0; left: 0;
    }
    .obsdimmertable {
      position: fixed; z-index: 101;
      width: 100%; height: 100%;
      top: 0; left: 0;
    }
    .obsdimmertext {
      font-size: x-large;
      font-weight: bold;
      background-color: #cfc;
      color: #000;
      padding: 1em;
      border: 3px solid #000;
      position: relative;
    }
    .obsdimmerclose {
      position: absolute;
      top: 3px; right: 3px;
      font-size: small;
      font-weight: lighter;
    }
    .obsdimmerclose a {
      background-color: #ccc;
      color: #000;
    }
    .obsdimmerclose a:hover {
      background-color: #fff;
    }
    @;
    .navitem {
      text-decoration: none;
      border-left: 3px solid #ffefd5;
      font-size: 88%;
    }
    .navlink a {
      padding: 0em 1em;
    }
    .navcurlink a {
      padding: 0em 1em;
      background-color: #060;
    }
    .navlink    a:hover,
    .navcurlink a:hover {
      background-color: #0a0;
    }
    @;
    .helpiconcell {
      text-align: right;
      text-vertical-align: top;
    }
    @;
    .helpicon {
      font-weight: bold;
      font-size: 88%;
    }
    @;
    .parlisttitle {
      margin-bottom: 0.5em;
    }
    .parlistitem {
      margin-bottom: 0.5em;
      margin-left: 2em;
    }
    @;
    .nolinkunderlines a {
      text-decoration: none;
    }
  })

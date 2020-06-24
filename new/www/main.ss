#lang at-exp s-exp "shared.ss"

(require "common.ss" "index.ss" "community.ss" "outreach+research.ss"
         "help.ss")

(set-navbar! index download docs planet community outreach+research)
(set-navbar-help! help)

(define/provide run render-all)

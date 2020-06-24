#reader"../common/html-script.ss"

(define title "Bug Report")
(define link-title "Report a Bug")
(define blurb
  @list{@font[color: 'red]{@em{Preferred method for reporting bugs:}}
        If possible, use the bug report interface built into DrScheme's Help
        Desk.  At the bottom of Help Desk's main page, you should see a link
        for sending bug reports.})

(define planet-bugs "http://planet.plt-scheme.org/trac/newticket")

(define (make-options opts)
  (apply splice
         (map (lambda (s)
                (if (eq? '* (car s))
                  @option[selected: 'true value: (caddr s)]{@(cadr s)}
                  @option[value: (cadr s)]{@(car s)}))
              opts)))

;; starred one is default
(define platform-option-links
  (make-options '((* "...or choose" "")
                  ("Windows Vista" "windows-vista")
                  ("Windows XP" "windows-xp")
                  ("Windows 2000" "windows-2000")
                  ("Windows NT" "windows-nt")
                  ("Windows 95/98/Me" "windows-9x")
                  ("Macintosh PowerPC (MacOS X)" "mac-ppc-osx")
                  ("Macintosh Intel (MacOS X)" "mac-i386-osx")
                  ("Linux, Fedora/RedHat based" "linux-fedora")
                  ("Linux, Ubuntu/Debian based" "linux-ubuntu")
                  ("Linux, other distro" "linux-other")
                  ("Sun Solaris" "solaris")
                  ;; ("Sun Solaris 8" "solaris-8")
                  ;; ("Sun Solaris, other version" "solaris-other")
                  ("Other Unix" "unix-other")
                  ;; ("Macintosh PowerPC (MacOS Classic)" "mac-ppc-macos")
                  ;; ("Macintosh 68K" "mac-68k")
                  ;; ("BeOS" "beos")
                  ;; ("MzScheme kernel" "mzkernel")
                  )))

;; starred one is default
(define severity-option-links
  (make-options '(("critical" "critical")
                  (* "serious" "serious")
                  ("non-critical" "non-critical"))))

;; starred one is default
(define bug-class-option-links
  (make-options '((* "software bug" "sw-bug")
                  ("documentation bug" "doc-bug")
                  ("change request" "change-request")
                  ("support" "support"))))

(define captchas '(["captcha1.jpg" "boogz"]
                   ["captcha2.jpg" "buhgz"]
                   ["captcha3.jpg" "gubz"]))

(define-values (captcha-file captcha-text)
  (apply values (list-ref captchas (random (length captchas)))))

(define script*
  (let ()
    (define (script* . body)
      (script type: 'text/javascript
        (apply literal
               `("\n"
                 ,@(map (lambda (x) (if (string? x) x (format "~a" x))) body)
                 "\n"))))
    @script*{
      var bugform = null;
      var browser_platform = "";
      var params  = new Array();
      var cookies = new Array();

      function initBugData() {
        bugform = document.getElementById("BugForm");
        if (navigator.platform && navigator.platform != "")
          browser_platform = navigator.platform;
        if (navigator.cpuClass && navigator.cpuClass != "")
          browser_platform += " / " + navigator.cpuClass;
        if (navigator.userAgent && navigator.userAgent != "")
          browser_platform += " / " + navigator.userAgent;
        if (location.search.length > 0) {
          var paramstrs = location.search.substring(1).split(/[;&]/);
          for (var i in paramstrs) {
            var param = paramstrs[i].split(/=/);
            if (param.length == 2)
              params[param[0]] = unescape(param[1]).replace(/\+/g," ");
          }
        }
        if (document.cookie.length > 0) {
          var cookiestrs = document.cookie.split(/; */);
          for (var i in cookiestrs) {
            var eql = cookiestrs[i].indexOf('=');
            if (eql >= 0)
              cookies[cookiestrs[i].substring(0,eql)] =
                unescape(cookiestrs[i].substring(eql+1));
          }
        }
        if (params["v"]) bugform.version.value = params["v"];
        DoUserFields(RestoreUserField);
        if (bugform.platform.value == "") {
          if (bugform.platform_options.selectedIndex == 0) UpdatePlatformUser();
          else UpdatePlatformOptions();
        }
        if (bugform.email.value == "")     bugform.email.focus();
        else if (bugform.name.value == "") bugform.name.focus();
        else                               bugform.subject.focus();
      }

      function SaveUserField(field, name) {
        if (field.value != "") {
          var d = new Date();
          d.setTime(d.getTime()+(365*24*60*60*1000));
          document.cookie = name + "=" + escape(field.value)
                          + "; expires="+ d.toGMTString()
                          + "; path=/";
        }
      }
      function RestoreUserField(field, name) {
        if (field.value == "" && cookies[name]) field.value = cookies[name];
      }
      function DoUserFields(op) {
        op(bugform.email, "email");
        op(bugform.name, "name");
        op(bugform.version, "version");
        op(bugform.platform, "platform");
        op(bugform.platform_user, "platform_user");
        op(bugform.platform_options, "platform_options");
      }

      function CheckSubmit() {
        DoUserFields(SaveUserField);
        if (bugform.email.value == "") {
          window.alert("Please enter an Email");
          return false;
        }
        if (bugform.subject.value == "" && bugform.description.value == "") {
          window.alert("Please enter a summary and/or a description"
                       + " of your bug");
          return false;
        }
        if (bugform.version.value == "") {
          window.alert("Please enter your PLT Scheme version");
          return false;
        }
        return true;
      }

      var old_platform_user = null;
      function UpdatePlatformUser() {
        var newval = bugform.platform_user.value;
        if (old_platform_user != newval) {
          if (newval == "" && old_platform_user != browser_platform) {
            newval = browser_platform;
            bugform.platform_user.value = browser_platform;
            bugform.platform_user.select();
          }
          bugform.platform.value = newval;
          bugform.platform_options.selectedIndex = 0;
          bugform.platform_user.focus();
          old_platform_user = newval;
        }
      }

      function UpdatePlatformOptions() {
        var d = new Date();
        var opts = bugform.platform_options;
        var newval = opts.options[opts.selectedIndex].value;
        if (newval == "") {
          bugform.platform.value = browser_platform;
          bugform.platform_user.value = old_platform_user = browser_platform;
        } else {
          bugform.platform.value = newval;
          bugform.platform_user.value = old_platform_user = "...or type";
        }
        bugform.platform_user.select();
        opts.focus();
      }
    }))

(define (run)
  (write-tall-page (PLT title) #:search 'bugs
    #:head-stuff (list script*)
    #:extra-body-attrs `([onLoad "initBugData();"])
    @table[align: 'center width: '70% cellpadding: 0 cellspacing: 0]{
      @tr{@td{
        @p{@em{@font[color: 'red]{
           If you can, please use the Bug Report item in DrScheme's
           Help menu. It works better than this page, because it helps
           you supply precise information about your PLT Scheme
           installation and working environment.}}}
        @p{Bug reports for PLaneT packages are submitted here:
           @tt{@a[href: planet-bugs]{@planet-bugs}}.}
        @p{Before submitting a bug report, you may wish to:
           @ul{@li{Check the
                   @a[href: (url "/download/doc/drscheme/")]{DrScheme manual}.}
               @li{@a[href: (url "/download/")]{Download}
                   a newer version of the PLT software package you're using.
                   DrScheme displays its version number on startup, and on in
                   its Help | About box.}
               @li{@a[href: (url "query/")]{Query existing bug reports}
                   by number or keyword.}}}
        @form[action: (url "/cgi-bin/bug-report") method: 'post
              id: "BugForm" onsubmit: "return CheckSubmit();"
              style: (concat "border: 2px solid #44f;"
                             " background-color: #eef;"
                             " padding: 6px;")]{
          @b{Your name:}
          @br{}
          @input[type: 'text name: 'name value: "" size: 40]
          @br{}@br{}
          @b{Your e-mail address:}
          @br{}
          @input[type: 'text name: 'email value: "" size: 40]
          @br{}@br{}
          @b{Summary of the problem:}
          @br{}
          @input[type: 'text name: 'subject value: "" size: 60]
          @br{}@br{}
          @table{
            @tr{@td{@b{Version:}}
                @td{@input[type: 'text name: 'version value: "" size: 14]}}
            @tr{@td{@b{Platform:}}
                @td{@input[type: 'text name: 'platform_user size: 30
                           onchange: "UpdatePlatformUser();"
                           onkeyup: "UpdatePlatformUser();"]@;
                    @|nbsp|@;
                    @select[name: 'platform_options
                            onchange: "UpdatePlatformOptions();"]{
                      @platform-option-links}@;
                    @input[type: 'hidden name: 'platform]}}
            @tr{@td{@b{Severity:}}
                @td{@select[name: 'severity]{@severity-option-links}}}
            @tr{@td{@b{Class:}}
                @td{@select[name: 'class]{@bug-class-option-links}}}}
          @br{}
          @b{Description of the problem:}
          @br{}
          @textarea[name: 'description rows: 15 cols: 70
                    style: "font-family:monospace"]{@""}
          @br{}@br{}
          @b{If possible, please give a short sequence of steps to reproduce
             the problem:}
          @br{}
          @textarea[name: 'how-to-repeat rows: 10 cols: 70
                    style: "font-family:monospace"]{@""}
          @br{}
          Please type @img[src: captcha-file align: 'middle]:
            @input[type: 'text name: 'captcha value: "" size: 10]
          @br{}@br{}
          @input[type: 'submit value: "Submit"]
          @nbsp
          @input[type: 'reset value: "Reset"]}}}}))

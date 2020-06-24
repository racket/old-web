#reader"../../common/html-script.ss"

(define title "Screen Shots")
(define blurb
  @`{Screenshots of DrScheme in action.})

(require "utilities.ss" "conf.ss")

(define thumbs
  (div align: 'center id: 'thumbs-bar
    (img id: 'tspace src: "blank.png" width: 1 height: 0 border: 0 vspace: 0)
    (br)
    (apply splice
           (mappend
            (lambda (image)
              (define num (image-num image))
              (list (a href:  (image-file image)
                       title: (image-title image)
                       id:    (format "link_~a" (image-num image))
                       onfocus: (format "thumb_focus(~a);" num)
                       onblur:  (format "thumb_blur();")
                       onclick: (format "image_select(~a);" num)
                      (img src: (image-thumb image)
                           border: 0 vspace: 0 style: "z-index: 2;"
                           width: min-width height: min-height
                           alt: (image-title image)
                           id: (format "thumb_~a" (image-num image))
                           onmouseover: (format "thumb_focus(~a);" num)
                           onmouseout:  (format "thumb_blur();")))
                    (br)))
            images))
    (img id: 'bspace src: "blank.png" width: 1 height: 0 border: 0 vspace: 0)))

(define bubble
  @table[id: 'bubble cellpadding: 0 cellspacing: 0 border: 0
         style: (concat "position: absolute; top: 0px; left: 0px;"
                        " visibility: hidden;")]{
    @tr{@td[valign: 'top]{
          @img[src: "bg.png" width: 4 height: 4 id: 'bubble-vbar]}
        @td[valign: 'top]{
          @img[src: "bg.png" width: 4 height: 4 vspace: 8 id: 'bubble-hbar]}
        @td[valign: 'top width: thumb-width]{
          @p[id: 'bubble-text
             style: @concat{font-size: 8pt; @;
                            border: 4px solid #@bubble-bcolor; @;
                            background-color: #@bubble-color;}
             onmouseover: "bubble_focus();" onmouseout: "bubble_blur();"]{
            @nbsp}}}})

(define loading-message
  @table[id: 'loading-msg
         style: "position: absolute; top: 0px; left: 0px; visibility: hidden;"
         width: (number->string image-width)
         height: (number->string image-height)
         cellpadding: 0 cellspacing: 0 border: 0]{
    @tr{@td[align: 'center valign: 'middle]{
          @span[style: (concat " font-weight: bolder; font-size: 300%;"
                               " font-family: sans-serif;"
                               " border: 2px solid #000000;"
                               " background-color: #c0c0c0;"
                               " opacity: 0.75;"
                               ;; IE hack: use filter, and require positioning
                               " filter: alpha(opacity=75); zoom: 1;")]{
            Loading...}}}})

(define script*
  (let ()
    (define (script* . body)
      (script type: 'text/javascript
        (apply literal
               `("\n"
                 ,@(map (lambda (x) (if (string? x) x (format "~a" x))) body)
                 "\n"))))
    (define (gen-array op . ->s)
      (let ([->s (if (null? ->s) (lambda (x) (format "~s" x)) (car ->s))])
        (concat "["
                (apply concat
                       (cdr (mappend (lambda (i) (list "," (->s (op i))))
                                     images)))
                "]")))
    @script*{
      // Written by Eli Barzilay <eli@"@"barzilay.org>
      // If you see this, then you know there's not much I can do to prevent
      // copying, but it would be nice if you mention where you got the code
      // from.  Thanks.  If you won't, then you'll get 7 years of bad karma,
      // horrible bugs, and router failures.

      var thumbs = @(gen-array
                     (lambda (img)
                       (format "document.getElementById(\"thumb_~a\")"
                               (image-num img)))
                     values);
      var blurbs = @(gen-array image-blurb);
      var titles = @(gen-array image-title);
      var shots  = @(gen-array image-file);
      var heights = @(gen-array (lambda _ min-height));

      var tspace      = document.getElementById("tspace");
      var bspace      = document.getElementById("bspace")
      var thumbs_bar  = document.getElementById("thumbs-bar");
      var screenshot  = document.getElementById("screenshot");
      var blurb       = document.getElementById("blurb");
      var bubble      = document.getElementById("bubble");
      var bubble_vbar = document.getElementById("bubble-vbar");
      var bubble_hbar = document.getElementById("bubble-hbar");
      var bubble_text = document.getElementById("bubble-text");
      var loading_msg = document.getElementById("loading-msg");

      // javascript enabled, so change the links
      for (i = 0; i < @(length images); i++)
        document.getElementById("link_"+i).href
          = "javascript:image_select(" + i + ");";

      var thumbs_bar_x = 0;
      var thumbs_bar_y = 0;
      function set_thumbs_bar_pos() {
        thumbs_bar_x = 0;
        thumbs_bar_y = 0;
        var item = thumbs_bar;
        while (item.offsetParent) {
          thumbs_bar_x += item.offsetLeft;
          thumbs_bar_y += item.offsetTop;
          item = item.offsetParent;
        }
      }

      document.getElementsByTagName("body")[0].onmousemove =
        function(e) {
          // see http://dunnbypaul.net/js_mouse/
          var x, y;
          if (!e) e = window.event;
          if (e) {
            if (e.pageX) {
              x = e.pageX;
              y = e.pageY;
            } else if (e.clientX) {
              x = e.clientX + document.body.scrollLeft
                            + document.documentElement.scrollLeft;
              y = e.clientY + document.body.scrollTop
                            + document.documentElement.scrollTop;
            }
            if (x) {
              set_thumbs_bar_pos(thumbs_bar);
              x = Math.max(x - thumbs_bar_x - @thumb-width, thumbs_bar_x - x);
              if (x < 0) x = 0; else x /= @(* thumb-width horiz-radius);
              y = (y - thumbs_bar_y - @padding) / @min-height - 0.5;
              set_center(x, y);
            }
          }
        }

      var size_func = @size-func;
      var thumbs_height = @(+ (* 2 padding) (* (length images) min-height));

      function set_center(x, y) {
        var totalH = 0;
        for (i = 0; i < @(length images); i++) {
          var dist = Math.abs(i - y);
          h = @min-height;
          if (dist < @zoom-radius && x < 1)
            h += size_func(dist / @zoom-radius)
                 * @(- thumb-height min-height)
                 * size_func(x);
          var ih = Math.round(h);
          if (heights[i] != ih) {
            heights[i] = ih;
            thumbs[i].height = ih;
            thumbs[i].width  = Math.round(h * @image-ratio);
          }
          totalH += ih;
        }
        totalH = (thumbs_height - totalH) / 2;
        tspace.height = Math.floor(totalH);
        bspace.height = Math.ceil(totalH);
        update_bubble();
      }

      var bubble_item = -1;
      var bubble_item_last = -1;
      function update_bubble() {
        if (bubble_item < 0) {
          if (bubble_item != bubble_item_last)
            bubble.style.visibility = "hidden";
        } else {
          var w = thumbs[bubble_item].width;
          var x = Math.ceil(thumbs_bar_x + @(/ thumb-width 2) + w / 2)
          var y = thumbs_bar_y + tspace.height;
          for (i = 0; i < bubble_item; i++) y += heights[i];
          bubble_vbar.height = heights[bubble_item];
          bubble_hbar.width  = (@thumb-width - w) / 2 + 8;
          bubble.style.left  = "" + x + "px";
          bubble.style.top   = "" + y + "px";
          if (bubble_item != bubble_item_last) {
            bubble_text.innerHTML = blurbs[bubble_item];
            bubble.style.visibility = "visible";
          }
        }
        bubble_item_last = bubble_item;
      }

      var bubble_timer = null;
      function do_bubble(n) {
        stop_bubble_timer();
        set_thumbs_bar_pos();
        bubble_item = n;
        update_bubble();
      }
      function stop_bubble_timer() {
        if (bubble_timer != null) {
          var t = bubble_timer;
          bubble_timer = null;
          clearTimeout(t);
        }
      }

      function thumb_focus(n) {
        stop_bubble_timer();
        bubble_timer = setTimeout("do_bubble("+n+")", @bubble-delay-in);
      }
      function thumb_blur() {
        stop_bubble_timer();
        bubble_timer = setTimeout("do_bubble(-1)", @bubble-delay-out);
      }
      function thumb_blur_now() {
        stop_bubble_timer();
        do_bubble(-1);
      }

      function bubble_focus() { stop_bubble_timer(); }
      function bubble_blur()  { thumb_blur(); }

      function image_select(n) {
        var item = screenshot, x = 0, y = 0;
        while (item.offsetParent) {
          x += item.offsetLeft;
          y += item.offsetTop;
          item = item.offsetParent;
        }
        loading_msg.style.left = x;
        loading_msg.style.top  = y;
        loading_msg.style.visibility = "visible";
        screenshot.src   = shots[n];
        screenshot.alt   = titles[n];
        screenshot.title = titles[n];
        blurb.innerHTML  = blurbs[n];
      }

      set_center(-2 * @zoom-radius);
      function init_screenshots() {
        set_center(-2 * @zoom-radius);
        thumb_blur_now();
        image_select(Math.floor(Math.random()*@(length images)));
      }}))

(define (run)
  (render-images+thumbs)
  (write-tall-page (PLT title) #:wide? #t
                   #:extra-body-attrs '([onload "init_screenshots();"])
    @table[width: (+ thumb-width image-width)
           align: 'center cellpadding: 0 cellspacing: 0 border: 0]{
      @tr{@td[width: thumb-width valign: 'top align: 'left]{
            @thumbs}
          @td[valign: 'top align: 'center width: image-width]{
            @img[src: initial-image id: 'screenshot
                 width: image-width height: image-height
                 onload: "loading_msg.style.visibility=\"hidden\";"]
            @loading-message}}
      @tr{@td{@""}
          @td[valign: 'top align: 'center width: image-width
              bgcolor: blurb-color]{
            @big[id: 'blurb]{@nbsp}}}}
    bubble
    script*))

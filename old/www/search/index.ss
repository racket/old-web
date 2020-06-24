#reader"../../common/html-script.ss"

(define title "Search")

(require "../../search/search-info.ss")

(define search-form
  @form[id: form-id action: (url "")]{
    @input[type: 'hidden name: 'cx  value: plt-id]
    @input[type: 'text   name: 'q   size:  12]
    @input[type: 'hidden name: 'hq  value: "more:plt"]
    @input[type: 'submit name: 'sa  value: "Search PLT"]
    @input[type: 'hidden name: 'cof value: "FORID:11"]})

(require net/uri-codec)

(define (run)
  (write-tall-page (PLT title) #:search 'results
    @div[id: results-id align: 'center]{}
    @script[type: "text/javascript"]{@||
      var googleSearchIframeName = "@results-id";
      var googleSearchFormName = "@form-id";
      // var googleSearchFrameWidth = 600;
      // var googleSearchFrameborder = 0;
      var googleSearchDomain = "www.google.com";
      var googleSearchPath = "/cse";
      @||}
    ;; Use my hacked version instead of Google's
    ;; @script[type="text/javascript"
    ;;         src="http://www.google.com/afsonline/show_afs_search.js"]
    @script[type: "text/javascript" src: "show_afs_search.js"]{}))

#| Original code from Google:

<!-- Google CSE Search Box Begins -->
<form id="searchbox_010927490648632664335:4yu6uuqr9ia" action="http://www.plt-scheme.org/search/">
  <input type="hidden" name="cx" value="010927490648632664335:4yu6uuqr9ia" />
  <input name="q" type="text" size="40" />
  <input type="submit" name="sa" value="Search" />
  <input type="hidden" name="cof" value="FORID:11" />
</form>
<script type="text/javascript" src="http://www.google.com/coop/cse/brand?form=searchbox_010927490648632664335%3A4yu6uuqr9ia"></script>
<!-- Google CSE Search Box Ends -->

<!-- Google Search Result Snippet Begins -->
<div id="results_010927490648632664335:4yu6uuqr9ia"></div>
<script type="text/javascript">
  var googleSearchIframeName = "results_010927490648632664335:4yu6uuqr9ia";
  var googleSearchFormName = "searchbox_010927490648632664335:4yu6uuqr9ia";
  var googleSearchFrameWidth = 600;
  var googleSearchFrameborder = 0;
  var googleSearchDomain = "www.google.com";
  var googleSearchPath = "/cse";
</script>
<script type="text/javascript" src="http://www.google.com/afsonline/show_afs_search.js"></script>
<!-- Google Search Result Snippet Ends -->

|#

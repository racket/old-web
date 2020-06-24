#reader"../../common/html-script.ss"

(define title "Binding Spaces")

(define (run)
  (write-tall-page title
    @p{(@a[href: (string-append "http://list.cs.brown.edu/mailman/private/"
                                "plt-internal/2007-October/"
                                "thread.html#12848")]{
          Original thread})}
    @h2{Why Binding Spaces Make Sense}
    @p{With the notable exception of module names, all bindings in PLT Scheme
       use the same "binding space".  (The word "namespace" is often used for
       what I mean, but "namespace" has a different meaning in PLT Scheme.)
       The binding space is the same even for names that work in mutually
       distinct positions, which means that name collisions sometimes seem
       gratuitous.}
    @p{For example, a lexer regular-expression form like @tt{*} (Kleene star),
       can be used only within the pattern positions of a @tt{lexer} form.
       Those patterns are distinct from expression positions.  Nevertheless,
       lexer-form bindings are in the same space as expression-level bindings.
       In particular, @tt{*} is also a MzScheme function; to use both the
       lexer's @tt{*} and MzScheme's @tt{*} in a single scope, one of them has
       to be renamed for prefixed, even though the two @tt{*}s work only in
       mutually distinct positions.}
    @p{Here are some other examples:
       @ul{@li{The v4.0 @tt{require} form is macro-extensible, which means that
               sub-forms like @tt{rename}, @tt{prefix} and @tt{all-except} need
               bindings.  Such bindings can only be used in a @tt{require}
               form, and there are no expression positions inside a
               @tt{require} form.  Meanwhile, words like @tt{rename} and
               @tt{prefix} are often nice names for function bindings within a
               module.  The v4.0 @tt{provide} form is similarly
               macro-extensible.}
           @li{Type positions in Typed Scheme are distinct from expression
               positions.}
           @li{Pattern variables bound by @tt{syntax-case} and
               @tt{syntax-rules} can be used only in templates, and templates
               have no expression positions.  In his dissertation, Martin
               Gasbichler argues in favor of a distinct space for
               pattern-variable bindings.}}}
    @p{Adding some concept of "space" or "dimension" to bindings would allow
       short names, such as @tt{*} and @tt{rename}, to work for different
       contexts within the same scope.  Multiple spaces might also help
       discourage symbolic comparisons (such as @tt{rename} in the current
       @tt{require} form), which so often turns out to be the wrong idea
       (usually because it doesn't support macro extension).}
    @p{Meanwhile, the core macro/module system already has different binding
       spaces for different phases --- even a @tt{for-label} space, which is
       somewhat disconnected from phases.  By analogy, then, maybe it makes
       sense to build binding spaces into the core.}
    @h2{Why Binding Spaces Aren't Worthwhile in the Core}
    @p{Although the current macro+module system supports different spaces for
       different phases, it's not clear that the different spaces are actually
       useful.  An identifier very rarely has different bindings in different
       phases; normally, it's just a question of the phase levels in which an
       identifier has its "usual" binding.}
    @p{More significantly, it turns out that multiple binding spaces aren't
       actually a generalization in the direction of @tt{for-label}.  I
       previously characterized @tt{for-label} as a kind of "dimension" instead
       of "phase",but now I think that it really is a kind of infinitely
       distant phase (i.e., you never get around to evaluating anything in that
       phase).  Unlike different spaces for @tt{lexer} and @tt{require}
       bindings, a @tt{for-label} import implies different module-invocation
       actions than @tt{for-run} or @tt{for-syntax}.  Also, combining
       @tt{for-label} with @tt{for-expand} makes no sense, whereas a
       hypothetical @tt{for-require}, @tt{for-provide}, or @tt{for-type}
       dimension makes sense with any of @tt{for-run}, @tt{for-expand}, or
       @tt{for-label}.}
    @p{As far as I can tell, multiple binding spaces do correspond to a kind of
       suffix naming convention.  That is, when the @tt{lexer}, @tt{require},
       or typed-Scheme expander looks up a binding in a particular space, it
       could just as well add a space-specific suffix to the name.}
    @p{The only advantage of a distinct binding space, then, seems to be in
       separating the "suffix" from the base name (so that the suffix can't be
       used accidentally in the wrong context).  That doesn't seem like enough
       of an advantage to build into the macro/module core.}
    @p{Granted, adding a suffix is a kind of hack.  Also, we don't try to
       simulate modules via module-specific suffixes, even though the
       namespace facet of a module really is just a kind of suffix.  But
       modules do more than avoid name collisions, and suffixes don't fulfill
       the other roles.}
    @p{Another bit of potential complexity is in local bindings.  We could have
       @tt{let}, @tt{let-syntax}, and @tt{define} variants that combine an
       identifier with a binding space.  For the general case, we could have a
       variant of @tt{letrec-values+syntaxes} where the space for each binding
       is specified independently.}
    @h2{Whether to Use Separate Binding Spaces}
    @p{From everything I've considered so far, building separate spaces into
       the core looks like too much complexity for too little pay-off.
       Suffixes should work fine, if we want the effect of separate spaces.}
    @p{With that in mind, I'm still undecided on whether to use separate
       binding spaces at all (as simulated via suffixes).  Since there doesn't
       seem to be anything deeply new about separate binding spaces, I can't
       help thinking that they aren't inherently "right".  A single binding
       space is simpler for both programmers and documentation.}
    @p{We also have cases where a separate binding space won't work, because
       expressions and non-expressions are mixed.  The most prominent example
       is are forms like @tt{public} and @tt{init} in @tt{class}, which are
       mixed with definitions and expressions.  For such cases, we will
       continue to struggle with name collisions.}
    @p{Then again, if the @tt{class} form were designed in a language that
       encouraged separate spaces, maybe it would have a different syntax.
       It's tempting to start a deeper re-design to see the full effect of
       multiple binding spaces.  But not that tempting.}
    @i{Matthew Flatt@br{}2007-10-15}))

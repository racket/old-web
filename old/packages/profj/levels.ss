#reader"../../common/html-script.ss"

(define title "Language Levels")

(import-from "index.ss" ProfJ)

(define level1 (ProfJ "Beginner"))
(define level2 (ProfJ "Intermediate"))
(define level3 (ProfJ "Advanced"))

(define (run)
  (write-tall-page (ProfJ title)
    @p{We believe that introductory students are not prepared for a full
       programming language with a professional compiler (and confusing error
       messages).  Therefore ProfessorJ presents three language levels that are
       designed to gradually introduce students to a professional language.
       These language levels @mdash Beginner, Intermediate, and Advanced
       @mdash prevent students from accidentally stumbling across features not
       yet seen in class.}
    @p{The manuals linked to below are for the current version of DrScheme, for
       other versions look at @(link-to 'docs).}
    @section{@level1}
    @a[href: "/download/doc/profj-beginner/"]{@level1 Language Manual}
    @p{@level1 presents basic object-oriented programming, where students learn
       to organize their data within class structures.
       @ul{@li{A class must have a constructor, and may implement one
               interface.}
           @li{Fields must be initialized, either in the constructor or at
               their declaration site.}
           @li{Methods must return a value.}
           @li{Fields and methods of the current class must be accessed using
               this.}}}
    @section{@level2}
    @a[href: "/download/doc/profj-intermediate/"]{@level2 Language Manual}
    @p{@level2 introduces abstraction, refinement inheritance, and mutable
       objects.
       @ul{@li{Classes may be abstract, may extend other classes, and may
               implement multiple interfaces.}
           @li{Fields do not require initialization and may be mutated.}
           @li{Methods may be used for effects.}}}
    @section{@level3}
    @a[href: "/download/doc/profj-advanced/"]{@level3 Language Manual}
    @p{@level3 introduces library programming, static vs. instance members, and
       iterative programming.
       @ul{@li{Methods and constructors may be overloaded.}
           @li{Classes may be grouped into new library packages.}}}
    @section{Screenshots}
    @i{TODO}))


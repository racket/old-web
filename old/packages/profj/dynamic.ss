#reader"../../common/html-script.ss"

(define title "Interoperability")

(import-from "index.ss" ProfJ)

(define dynamic @tt{@b{dynamic}})

(define (run)
  (write-tall-page (ProfJ title)
    @p{The ProfessorJ Java + @dynamic extends Java with a new type keyword,
       dynamic, and the ability to directly import libraries written in Scheme
       as well as Java.}
    @p{The paper
       @a[href: "http://www.cs.utah.edu/~kathyg/interop.pdf"]{
         @i{Fine Grained Interoperability through Mirrors and Contracts}}
       presents the full details of this extension.}
    @section{Importing Scheme libraries}
    @p{In the Java + dynamic language, the import statement
       @pre{import scheme.lib.mred.mred;} directs the compiler to allow the
       current program to use values provided by the PLT library collection
       @tt{mred.ss} located in the @tt{mred} directory.}
    @p{The import statement @pre{import scheme.interp.scripts;} directs the
       compiler to allow the current program to use values provided by the
       @tt{script.ss} module located in the interp directory, found using the
       standard classpath.}
    @p{Within the body of the Java program, a Scheme value is accessed using
       the same style as a static member of a class (where a module is seen as
       a class).}
    @p{So, @pre{mred.frameObj} in a program importing MrEd allows the Java
       programmer to access the class of the MrEd library.  Within the Java
       program, this value carries no static type information and can legally
       appear in any Java value context.  During execution, dynamic checks will
       ensure that Java type guarantees are not violated.}
    @p{Scheme functions and methods may be called within the Java program, and
       Java values may be passed in as arguments,
       @pre{scripts.buildTaxEnv(new TaxCalc())}
       The Java value is embedded within a contract that ensures Java type
       guarantees are not violated when the Scheme program accesses the Java
       value.}
    @section{Using @dynamic}
    @p{In Java + @dynamic, any position that expects a type (except an
       @tt{instanceof} expression) can have the type @dynamic as well as the
       original Java types.  Such a declaration ensures that no static errors
       may arise due to the use of the value with this specified type.  Any
       necessary checks to ensure Java's other static type guarantees will be
       performed at run time.}
    @i{TODO}
    @section{Java Values within Scheme}
    @i{TODO}
    @section{A Matter of Names}
    @i{TODO}
    @section{Java + @dynamic and the Teaching languages}
    @i{TODO}
    ))

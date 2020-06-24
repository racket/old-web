#reader"../../common/html-script.ss"

(define title "Testing Support")

(import-from "index.ss" ProfJ)

(define (run)
  (write-tall-page (ProfJ title)
    @p{ProfessorJ implements linguistic support for writing and executing unit
       tests in each of its language levels.}
    @p{The pedagogic levels implement a more restricted form of these
       extensions, as they implement a more restricted form of the overall
       language.}
    @section{Pedagogic testing}
    @p{TODO}
    @section{Full Testing Extension}
    @p{TODO}
    @section{Test Reports}
    @p{TODO}
    @section{Enabling/Disabline Options}
    @p{TODO}))

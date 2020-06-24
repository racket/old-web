#reader"../../common/html-script.ss"

(define title "Listas de Correo")
(define blurb @`{Lista de correo para discusi@|oacute|n en espa@|ntilde|ol.})

(define list-url "http://list.cs.brown.edu/mailman/listinfo/plt-scheme-es/")
(define archive-url "http://list.cs.brown.edu/pipermail/plt-scheme-es/")
(define list-email "plt-scheme-es@list.cs.brown.edu")
(define request-email "plt-scheme-es-request@list.cs.brown.edu")
(define old-url "http://www.cs.utah.edu/plt/mailarch/es/")

(define (run)
  (write-tall-page (PLT title)
    @a[href: (url "index.html")]{PLT Mailing Lists in English}
    @br{}
    @section{Lista de Correo}
    @p{Tenemos una lista de correo para discusi@|'oacute|n en espa@|'ntilde|ol.
       Aqu@|'iacute| est@|'aacute| @a[href: archive-url]{el archivo de Web} de
       la lista.
       (Los mensajes anteriores al 13-06-2002 est@|'aacute|n en el
       @a[href: old-url]{archivo viejo}.)}
    @p{Si tienes problemas con la instalaci@|'oacute|n o preguntas sobre el uso
       de PLT Scheme (@|'iexcl|por favor no env@|'iacute|es preguntas de tus
       tareas!), env@|'iacute|a un mensaje a la lista
       @blockquote{@code{@list-email}}
       Para reducir la recepci@|'oacute|n de mensajes no deseados (SPAM), hemos
       adoptado la pol@|'iacute|tica de que s@|'oacute|lo los suscriptores a la
       lista pueden enviar mensajes.
       Para suscribirte, visita la p@|'aacute|gina de Web
       @blockquote{@code{@a[href: list-url]{@list-url}}}
       o env@|'iacute|a un mensaje a
       @blockquote{@code{@request-email}}
       con la palabra `help' en el asunto o en el cuerpo de tu mensaje.
       Recibir@|'aacute|s un mensaje de regreso con instrucciones.}))

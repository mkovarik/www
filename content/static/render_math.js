$("script[type='math/tex']").replaceWith(function() {
    var formula = $(this).text();
    return katex.renderToString(formula, {displayMode: false});
});

$("script[type='math/tex; mode=display']").replaceWith(function() {
    var formula = $(this).html();
    formula = formula.replace(/%.*/g, '');
    return katex.renderToString(formula, {displayMode: true});
});

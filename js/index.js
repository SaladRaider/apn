wow = new WOW(
{
    boxClass:     'wow',      // default
    animateClass: 'animated', // default
    offset:       50,          // default
    mobile:       true,       // default
    live:         true        // default
});
wow.init();

$('.btn-see-down').click(function(){
    $('html, body').animate(
        {scrollTop: $('#page-content-start').offset().top - 48}, 
        1000);
})

$(window).load(function(){
    if($(window).width() < 768) {
        $('.navbar-scroll').show();
    }
    $('#show-case-video').prop("volume","0.5");
})

$(window).resize(function(){
    if($(window).width() < 768) {
        $('.navbar-scroll').show();
        $('.navbar-scroll').css("opacity", "1");
        $('.navbar-scroll').css("top", "0");
    } else {
        if($('.collapseable-menu').is(":visible")) {
            $('.collapseable-menu').hide();
            $('.navbar-scroll').css("height", "48px");
        }
        if($(window).scrollTop() < 48*2
        && $('.navbar-scroll').css("opacity") != "0"
        && $(window).width() >= 768) {
            $('.navbar-scroll').animate({
                "opacity":"0",
                "top":"-100px"},
                500,
                function(){$('.navbar-scroll').hide();}
            );
        }
    }
});

// check to see if below nav bar 
$(window).bind('scroll', function() {

    if($(window).scrollTop() < $(window).height() - 48) {
        $('.show-case-video').prop("volume", 
            ($(window).height() - 48 - $(window).scrollTop()) / ($(window).height() - 48) / 2);
    }
    else  {
        $('.show-case-video').prop("volume","0.0");
    }

    if($('.navbar-scroll').is(':animated')) {
        return;
    }
    if($(window).scrollTop() > 48*4
        && $('.navbar-scroll').css("opacity") == "0"
        || $(window).width() < 768) {
        $('.navbar-scroll').show();
        $('.navbar-scroll').animate({
            "opacity":"1",
            "top":"0"},
            500
        );
    } else if($(window).scrollTop() < 48*2
        && $('.navbar-scroll').css("opacity") != "0"
        && $(window).width() >= 768) {
        $('.navbar-scroll').animate({
            "opacity":"0",
            "top":"-100px"},
            500,
            function(){$('.navbar-scroll').hide();}
        );
    }
});

$('.nav-ham-toggle').click(function() {
    if(!$('.collapseable-menu').is(":visible")) {
        $('.navbar-scroll').css("height", "auto");
        $('.collapseable-menu').show(500);
    } else {
        
        $('.collapseable-menu').hide(500,function(){
            $('.navbar-scroll').css("height", "48px");
        });
    }
    
});
$(document).ready(function() {
    var sidebarLinks = $('li[data-youtube]');
    var notes = $('div[data-youtube]');
    var playVideo = function() {
        var youtubeVideoID = $(this).attr('data-youtube');
        $('#video-player')[0].src = "http://www.youtube.com/embed/" + youtubeVideoID + "?rel=0"
        
        sidebarLinks.removeClass('current');
        $(this).addClass('current');
        
        sidebarLinks.addClass('selectable');
        $(this).removeClass('selectable');
        
        notes.addClass('hidden');
        notes.filter('div[data-youtube="' + youtubeVideoID + '"]').removeClass('hidden');
    }
    sidebarLinks.click(playVideo);
    sidebarLinks.first().click();
});
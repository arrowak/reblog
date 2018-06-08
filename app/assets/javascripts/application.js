// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require jquery
//= require turbolinks
//= require bootstrap
//= require social-share-button
//= require summernote
//= require_tree .

var like = function(e, ele) {
  e.preventDefault();
  var url = $(ele).attr('data-link');

  $.ajax({
    url: url,
    success: function(data) {
      if (data != "false") {
        location.reload();
      } else {
        location.reload();
      }
    },
    error: function(data) {
      alert('Error');
    },
    async: true
  });

  return true;
};


var follow = function(e, ele) {
  e.preventDefault();
  var url = $(ele).attr('data-link');

  $.ajax({
    url: url,
    success: function(data) {
      if (data == "true") {
        $('#follow').addClass('hidden');
        $('#un-follow').removeClass('hidden');
      } else {

      }
    },
    error: function(data) {
      alert('Error');
    },
    async: true
  });

  return true;
};

var unfollow = function(e, ele) {
  e.preventDefault();
  var url = $(ele).attr('data-link');

  $.ajax({
    url: url,
    success: function(data) {
      if (data == "true") {
        $('#un-follow').addClass('hidden');
        $('#follow').removeClass('hidden');
      } else {

      }
    },
    error: function(data) {
      alert('Error');
    },
    async: true
  });

  return true;
};

var shareToFB = function(href){
  FB.init({
    appId: '814967478698676',
    status: true,
    cookie: true,
    xfbml: true
  });

  FB.ui({
    method: 'share',
    mobile_iframe: true,
    href: href,
  }, function(response){});
};


var imageUpload = function(summernoteObj, file) {
  data  = new FormData();
  data.append('cloudshare[image]', file);
  data.append('format', 'json');

  $.ajax({
    url: '/upload_image',
    data: data,
    type: 'POST',
    cache: false,
    contentType: false,
    processData: false,
    success: function(data) {
      img = document.createElement('IMG');
      img.src = data.link;
      $(summernoteObj).summernote('insertNode', img);
    }
  })

}




$(document).on('ready turbolinks:load page:load', function() {
  $.ajaxSetup({
    headers: {
      'X-CSRF-TOKEN': $('meta[name="csrf-token"]').attr('content')
    }
  });

  window.dataLayer = window.dataLayer || [];
  gtag('js', new Date());
  gtag('config', 'UA-36070617-2');


  $('#' + location.hash.substr(1)).addClass("blinkBackground blink");

  setTimeout(function() {
    $('#' + location.hash.substr(1)).removeClass("blinkBackground");
  }, 4000);

  $("a[href='#top']").click(function() {
    $("html, body").animate({
      scrollTop: 0
    }, "slow");
    return false;
  });

  $(document).scroll(function() {
    if (document.body.scrollTop > 1500 || document.documentElement.scrollTop > 1500) {
      $('#scroll-top').show();
    } else {
      $('#scroll-top').hide();
    }
  });

});

$(document).on('turbolinks:load', function() {

  window.searchResults = null;

  $('#searchbar').autocomplete({
    serviceUrl: '/search',
    groupBy: 'category',
    paramName: 'query',
    params: {
      'format': 'json'
    },
    minChars: 3,
    noCache: false,
    maxHeight: 500,
    tabDisabled: true,
    triggerSelectOnValidInput: false,
    onSelect: function(suggestion) {
      window.location.href = "/search/action?query=" + suggestion.name;
    }
  });


  $('.post-body p').has('img').css('text-indent', 0);

  $('[data-provider="summernote"]').summernote({
    height: 400,
    callbacks: {
      onImageUpload: function(files){
        img = imageUpload(this, files[0]);
      }
    }
  });

});

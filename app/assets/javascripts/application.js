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
//= require md_simple_editor
//= require bootstrap
//= require social-share-button
//= require_tree .

var like = function(e, ele) {
  e.preventDefault();
  var url = $(ele).attr('data-link');

  $.ajax({
    url: url,
    success: function(data) {
      if (data != "false") {
        $("#like-count").text(data);
        if ($('.liked').length == 0) {
          $(".like").after('<small><span class="liked glyphicon glyphicon-ok"></span><span class="liked">Liked</span></small>');
        }
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

});

var mdloaded = false;

$(document).on('turbolinks:load', function() {

  window.searchResults = null;

  $('#searchbar').autocomplete({
    serviceUrl: '/search',
    groupBy: 'category',
    paramName: 'query',
    params: {'format': 'json'},
    minChars: 3,
    noCache: false,
    maxHeight: 500,
    tabDisabled: true,
    onSelect: function(suggestion) {
      window.location.href = "/search/action?query=" + suggestion.name;
    }
  });


  $('.post-body p').has('img').css('text-indent', 0);

  if (mdloaded) {
    (function() {
      var initializeEditor, insertAtCaret, md_simple_editor, preview;

      md_simple_editor = function() {
        return $('.btn-toolbar .btn-group button').click(function(e) {
          e.stopPropagation();
          e.preventDefault();
          var att_class, option, rgex, text, textarea;
          att_class = this.classList;
          rgex = /md_/;
          option = $.grep(att_class, function(item) {
            return rgex.test(item);
          });
          if (option.length !== 0) {
            option = option[0].toString();
            text = option === 'md_h1' ? "# Your Title here" : option === 'md_h2' ? "## Your Title here" : option === 'md_h3' ? "### Your Title here" : option === 'md_h4' ? "#### Your Title here" : option === 'md_h5' ? "##### Your Title here" : option === 'md_italic' ? "_Your italic text here_" : option === 'md_bold' ? "__Your bold text here__" : option === 'md_list-ul' ? "\n\n* Item 1\n* Item 2\n* Item 3 \n\n<br>" : option === 'md_list-ol' ? "\n\n1. Item 1\n2. Item 2\n3. Item 3 \n\n<br> " : option === 'md_indent' ? ">Your indented text here" : option === 'md_underline' ? "<u>Your undelined text here </u>" : option === 'md_table' ? "\n|Header|Header|Header|\n|:------|:-------:|------:|\n|Left alignment|Centered|Right alignment|\n\n<br>" : option === 'md_minus' ? "\n<hr>\n" : option === 'md_square' ? "\n\t Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam ut aliquet velit. Nam fermentum, mi quis egestas ornare, massa velit pharetra ante, sed pellentesque tortor nisl non quam. Nunc eget egestas orci.\n\n<br> " : option === 'md_link' ? "\n[This is a link](http://google.com)\n" : option === 'md_camera-retro' ? "\n![Alt](https://www.google.com.co/images/srpr/logo11w.png)\n" : void 0;
            textarea = $('#md-editor #md-text textarea');
            return insertAtCaret(textarea.attr('id'), text);
          }
        });
      };

      preview = function() {
        if ($('#md-text').prop('hidden')) {
          $('.preview_md').text('Preview');
          $('#md-text').removeAttr('hidden');
          $('.preview-panel').attr('hidden', 'true');
          return false;
        } else {
          return $.post('/md_simple_editor/preview', {
            md: $('#md-text textarea').val()
          }, function(data) {
            $('.preview_md').text('Editor');
            $('#md-text').attr('hidden', 'true');
            $('.preview-panel').removeAttr('hidden');
            return $('#md-preview').html(data);
          });
        }
      };

      insertAtCaret = function(areaId, text) {
        var back, br, front, range, scrollPos, strPos, txtarea;
        txtarea = document.getElementById(areaId);
        scrollPos = txtarea.scrollTop;
        strPos = 0;
        br = (txtarea.selectionStart || txtarea.selectionStart === "0" ? "ff" : (document.selection ? "ie" : false));
        if (br === "ie") {
          txtarea.focus();
          range = document.selection.createRange();
          range.moveStart("character", -txtarea.value.length);
          strPos = range.text.length;
        } else {
          if (br === "ff") {
            strPos = txtarea.selectionStart;
          }
        }
        front = txtarea.value.substring(0, strPos);
        back = txtarea.value.substring(strPos, txtarea.value.length);
        txtarea.value = front + text + back;
        strPos = strPos + text.length;
        if (br === "ie") {
          txtarea.focus();
          range = document.selection.createRange();
          range.moveStart("character", -txtarea.value.length);
          range.moveStart("character", strPos);
          range.moveEnd("character", 0);
          range.select();
        } else if (br === "ff") {
          txtarea.selectionStart = strPos;
          txtarea.selectionEnd = strPos;
          txtarea.focus();
        }
        return txtarea.scrollTop = scrollPos;
      };

      initializeEditor = function() {
        md_simple_editor();
        $(document).off('turbolinks:load page:load ready', initializeEditor);
        return $('.preview_md').click(function() {
          return preview();
        });
      };

      $(document).on('turbolinks:load page:load ready', initializeEditor);

    }).call(this);
  }
  mdloaded = true;
});

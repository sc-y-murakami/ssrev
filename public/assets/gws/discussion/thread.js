this.Gws_Discussion_Thread=function(){function t(){}return t.render=function(c){var s=function(t,e,i){var n=$("<span></span>"),a=$('<img src="/assets/img/gws/ic-file.png" alt="" />'),o=$('<a target="_blank"></a>'),s=$('<input type="hidden" name="item[file_ids][]" class="file-id" />'),r=$('<i class="material-icons md-18 md-inactive deselect">close</i>');n.attr("data-file-id",e),n.attr("id","file-"+e),o.text(i),o.attr("href","/.u"+c+"/apis/temp_files/"+e+"/view"),s.attr("value",e),r.on("click",function(){return $(this).parent("span").remove(),$(t).find("[data-file-id]").length<=0&&$(t).hide(),!1}),n.append(a),n.append(o),n.append(r),n.append(s),$(t).show(),$(t).append(n)};$("a.ajax-box").data("on-select",function(t){var e,i,n;return n=$.colorbox.element().closest(".comment-files").find(".selected-files"),e=t.data("id"),i=t.data("humanized-name"),s(n,e,i),$.colorbox.close()});var t={select:function(t,o){return $(t).each(function(t,e){var i,n,a;return a=$(o).closest(".comment-files").find(".selected-files"),i=e._id,n=e.name,s(a,i,n)}),!1}};new SS_Addon_TempFile($(".comment-files .upload-drop-area"),c,t),$(".open-reply").on("click",function(){return $(this).closest(".addon-body").next(".reply").show(),$(this).remove(),!1}),$(".reply[data-topic]").each(function(){var t=$(this).attr("data-topic"),e=function(){return $(".discussion-contributor"+t+" input#item_contributor_model").val($(this).data("model")),$(".discussion-contributor"+t+" input#item_contributor_id").val($(this).data("id")),$(".discussion-contributor"+t+" input#item_contributor_name").val($(this).data("name"))};return $(this).find(".discussion-contributor"+t+' input[name="tmp[contributor]"]').on("change",e),$(this).find(".discussion-contributor"+t+' input[name="tmp[contributor]"]:checked').each(e)})},t}();
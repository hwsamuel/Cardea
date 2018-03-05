tinymce.PluginManager.add('youtube', function(editor, url) {
    // Add a button that opens a window
    editor.addButton('youtube', {
        tooltip: 'Add YouTube Video',
        icon: 'media',
        onclick: function() {
            // Open window
            editor.windowManager.open({
                title: 'YouTube Plugin',
                body: [
                    {
						type: 'textbox', 
                        name: 'vid', 
                        label: 'Video ID'
					},
					{
						type: 'textbox', 
                        name: 'vw', 
                        label: 'Width'
					},
					{
						type: 'textbox', 
                        name: 'vh', 
                        label: 'Height'
					}
                ],
                onsubmit: function(e) {
                    // Insert content when the window form is submitted
                    var width, height;
                    if(e.data.vw)
                    {
						width = e.data.vw;
					}
					else
					{
						width = 400;
                    }
                    if(e.data.vh)
                    {
						height = e.data.vh;
					}
					else
					{
						height = 300;
                    }
                    if(e.data.vid)
                    {
                        editor.insertContent('<object width="'+width+'" height="'+height+'"><param name="movie" value="https://www.youtube.com/v/'+e.data.vid+'"></param><param name="allowScriptAccess" value="always"></param><embed src="https://www.youtube.com/v/'+e.data.vid+'" type="application/x-shockwave-flash" allowscriptaccess="always" width="'+width+'" height="'+height+'"></embed></object>');
                    }
                    else
                    {
						tinyMCE.activeEditor.windowManager.alert('Please fill the Video ID field to use YouTube plugin');
					}
                }
            });
        }
    });
});
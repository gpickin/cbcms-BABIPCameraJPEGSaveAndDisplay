/**
* ContentBox - A Modular Content Platform
* Copyright since 2012 by Ortus Solutions, Corp
* www.ortussolutions.com/products/contentbox
* ---
* ContentBox IP Camera Jpeg Save and Display Widget Module
*/
component extends="contentbox.models.ui.BaseWidget" singleton{

	property name="controller"			inject="coldbox";
	
	function init(){
		// Widget Properties
		setName( "BAB IP Camera Save and Display" );
		setVersion( "1.0" );
		setDescription( "ContentBox IP Camera Jpeg Save and Display Widget Module" );
		setAuthor( "Gavin Pickin - Black and Blue Web Apps" );
		setAuthorURL( "http://www.blackandbluewebapps.com" );
		setIcon( "camera" );
		setCategory( "Content" );
		return this;
	}

	/**
	* ContentBox IP Camera Jpeg Save and Display Widget Module
	*
	* @cameraURL.label IP Camera URL and User Creds
	* @cameraURL.hint Ex: http://yourname.ddns.net:8123/cgi-bin/CGIProxy.fcgi?cmd=snapPicture2&usr=usernamegoeshere&pwd=passwordgoeshere
	* @imageTitle.label Image Title
	* @imageTitle.hint Enter a Title for the Image. This will be used at the Alt Tag as well
	* @webRefresh.label Image Refresh Period 
	* @webRefresh.hint Number of seconds between ajax refreshes, 0 means no refresh.
	* @imageRefresh.label Image Cache Period
	* @imageRefresh.hint Number of seconds between image capture and save. If that time period has not passed, a cached image will be returned.
	* @cameraFolderLocation.label Save Image Path
	* @cameraFolderLocation.hint The path inside your media store you wish to store the IP Camera images - defaults to /ipcamera/
	* @additionalClasses.label Additional Image Classes
	* @additionalClasses.hint  Additional CSS Classes you wish to apply to the Image generated.
	*/
	any function renderIt( required string cameraURL, required string imageTitle="IP Camera", required numeric webRefresh=30, required numeric imageRefresh=6000, required cameraFolderLocation="/ipcamera/", string additionalClasses ){
		
		var divID = "BABIPCameraJPEGSaveAndDisplay_" & randRange( 10000,99999);
		
		session["ipCameraURL_#divID#"] = arguments.cameraURL;
		session["cameraFolderLocation_#divID#"] = arguments.cameraFolderLocation;
		session["imageRefresh_#divID#"] = arguments.imageRefresh;
		
		saveContent variable="generatedHTML"{
			writeOutput( '<img src="" alt="#arguments.imageTitle#" title="#arguments.imageTitle#" id="#divID#" class="img-responsive #arguments.additionalClasses#">' );
			writeOutput( '
				<script language="javascript">
	
				        function loadStats#divID#() {
				                $.ajax({
				                        url: "/BABIPCameraJPEGSaveAndDisplay",
				                        data: {
				                        	"divID": "#divID#"
				                        }
				                }).done(function( res  ) {
				                        $( "###divID#" ).attr( "src", res );
				                });
				        }
				
				        $( document ).ready(function() {
				                loadStats#divID#();
			');
				                
			if( arguments.webRefresh neq 0 ){
				writeOutput( 'setInterval(function(){ loadStats#divID#(); }, #arguments.webRefresh*1000#);' );	
			}
			writeOutput( '
				        });
				</script>
			');
		}
		

		return generatedHTML;
	}
	
}

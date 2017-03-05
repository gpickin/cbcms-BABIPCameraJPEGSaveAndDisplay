component{

	property name="settingService"  inject="id:settingService@cb";

	// Default Action
	function index( event, rc, prc ){
		param name="rc.divID" default="";
		param name="application.lastWebcamPicture" value="#createDate( 1999, 12, 31 )#";
		var cbSettings = variables.settingService.getAllSettings( asStruct=true );

		var ipCameraURL = getIfExists( session, "ipCameraURL_#rc.divID#" );
		var cameraFolderLocation = getIfExists( session, "cameraFolderLocation_#rc.divID#" );
		var imageRefresh = getIfExists( session, "imageRefresh_#rc.divID#" );
		
		try {
			var imageDateTime = now();
			var imageFolderDatePath = dateformat( imageDateTime, "yyyy/mm/dd/" );
			var imageName = timeformat( imageDateTime, "HH-mm-ss") & ".jpg";
				
			if( dateDiff( "s", application.lastWebcamPicture, imageDateTime ) gt imageRefresh ){
				var fullCameraFolderLocation = expandPath( cbSettings.cb_media_directoryRoot ) & cameraFolderLocation & imageFolderDatePath;
				if( ! directoryExists( fullCameraFolderLocation ) ){
					directoryCreate( fullCameraFolderLocation );	
				}
				var photoResult = "";
				http timeout="45"
					throwonerror="false"
					url="#ipcameraURL#"
					method="get"
					useragent="Mozilla/5.0 (Windows; U; Windows NT 6.0; en-US; rv:1.8.1.12) Gecko/20080201 Firefox/2.0.0.12"
					getasbinary="yes"
					result="photoResult"{
				}
				var newImage = ImageNew( photoResult.FileContent );
				imageWrite(newImage, expandPath( cbSettings.cb_media_directoryRoot ) & cameraFolderLocation & imageFolderDatePath & imageName );
				application.lastWebcamPicture = imageDateTime;
			} else {
				imageFolderDatePath = dateformat( imageDateTime, "yyyy/mm/dd/" );
				imageName = timeformat( application.lastWebcamPicture, "HH-mm-ss") & ".jpg";
			}
			
			writeOutput( "/__media/#cameraFolderLocation##imageFolderDatePath##imageName#" );
		} catch( e ){
			writeOutput( "http://semantic-ui.com/images/wireframe/image.png" );
		}
		event.noRender();
	}
	
	function getIfExists( scope, key ){
		if( structKeyExists( arguments.scope, arguments.key ) ){
			return arguments.scope[ "#arguments.key#" ];
		} else {
			return "";
		}
	}
}	
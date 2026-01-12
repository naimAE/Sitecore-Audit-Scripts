<%@ Page Language="C#" AutoEventWireup="true"   %>
<%@ Import Namespace="System.Data.Linq" %>
<%@ Import Namespace="System.Linq" %>
<%@ Import Namespace="Sitecore.Collections" %>
<%@ Import Namespace="Sitecore.SecurityModel" %>
<%@ Import Namespace="Sitecore.Data.Managers" %>
<%@ Import Namespace="Sitecore.Data" %>
<%@ Import Namespace="Sitecore.Data.Templates" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
    <script language="c#" runat="server">
       
            public static class Field
            {
                public static bool IsStandardTempalteField(Sitecore.Data.Templates.TemplateField field)// (Sitecore.Data.Fields.Field field)
                {
                    Sitecore.Data.Templates.Template template = Sitecore.Data.Managers.TemplateManager.GetTemplate(
                      Sitecore.Configuration.Settings.DefaultBaseTemplate,
                      Database.GetDatabase("master"));
                    Sitecore.Diagnostics.Assert.IsNotNull(template, "template");
                    return template.ContainsField(field.ID);
                }
            }
   

        public void Page_Load(object sender, EventArgs e)
        {
		  //Response.Write(Sitecore.Configuration.Settings.DefaultItem+"<BR>");
		 //   Response.Write(Sitecore.Context.Site.RootPath+"<BR>");
		
                
            //hello, world!
            GetItemCount();
            

            //foreach (var item in d)
            //{
            //    Response.Write(item.ToString()+"<BR>");
            //}
        }
				
		static int max=0;
		static string maxItemPath="";
		
		public int GetChildrens(Sitecore.Data.Items.Item item,int level=0)
        {
            
			//Response.Write(string.Format("Item [{0}]  <BR>", item.ToString()));
			int childrens=0;
            if (item != null)
            {
				if(max <item.Versions.Count)
				{
					max=item.Versions.Count;
					maxItemPath = item.Paths.FullPath;
				}
				
				if (item.Versions.Count>10) //disable to get a full list
					Response.Write(string.Format("{2} Item [{0}] - Version Count {1} <BR>", item.Paths.FullPath, item.Versions.Count, 
					new String('-', level) 
					));
			
                var items = item.GetChildren(Sitecore.Collections.ChildListOptions.IgnoreSecurity);

                if (items != null )
				
                {
					level++;
					childrens +=items.Count;
					
                    for(int i=0;i<items.Count;i++)
                    {
                       childrens += GetChildrens(items[i],level);
                    }
                }
            }
			
			return childrens;
        }

				
        public void GetItemCount()
        {

            using (new SecurityDisabler())
            {
                
               var home = Sitecore.Data.Managers.ItemManager.GetItem(
			   Sitecore.Context.Site.RootPath+Sitecore.Configuration.Settings.DefaultItem,
               Sitecore.Globalization.Language.Parse(Sitecore.Configuration.Settings.DefaultLanguage),
               Sitecore.Data.Version.First,
               Database.GetDatabase("master"));
				
				int childrens = GetChildrens(home);
				Response.Write("Max Versions count :"+max.ToString()+", Item ["+maxItemPath+"]<BR>");
				Response.Write("Total Childrens Found :"+childrens.ToString()+"<BR>");
				
				/*if (item != null)  
               {  
                    List<Item> items = this.GetItems(item);  
                    if (items.Count >= 100)  
                    {  
                         Response.Write(string.Format("Item [{0}] - Count {1} <BR>",item.ToString() , items.Count ));
                    }  
                }  */

            }
        }


    </script>
<head runat="server">
    <title></title>
    
</head>
<body>
    <form id="form1" runat="server">
    <div>
    
    </div>
    </form>
</body>
</html>

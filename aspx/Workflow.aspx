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
            //hello, world!
            var d= GetMultiFields();
            //Response.Write("Duplicates Fields Found :"+d.Count.ToString()+"<BR>");

            //foreach (var item in d)
            //{
            //    Response.Write(item.ToString()+"<BR>");
            //}
        }



        public List<string> GetMultiFields()
        {
            string[] multiList = { "{81CC0FB0-E6B8-44A2-869E-0011DA318891}" ,"{69FEBB4F-14A9-41C6-A5B9-B2AB760F4152}"};

            using (new SecurityDisabler())
            {
         
                TemplateDictionary dict = TemplateManager.GetTemplates(Database.GetDatabase("master"));

                List<string> duplicates = new List<string>();

                string reportLine = "Field '{1}' duplicated from templates '{2}'";
                string formatMsg = "Template {0}: Field Name {1} , Value {2}<BR>";
               foreach (KeyValuePair<ID, Template> templatePair in dict.Where(x=> !Sitecore.Data.ID.IsNullOrEmpty(x.Value.StandardValueHolderId)))
				 //foreach (KeyValuePair<ID, Template> templatePair in dict)
                {
					var stdItem =  ItemManager.GetItem(templatePair.Value.StandardValueHolderId,//templatePair.Value.StandardValueHolderId,
                       Sitecore.Globalization.Language.Parse(Sitecore.Configuration.Settings.DefaultLanguage),
                       Sitecore.Data.Version.First,
                        Database.GetDatabase("master"));
						
					if (stdItem.Fields["__Default workflow"] !=null && !string.IsNullOrEmpty(stdItem.Fields["__Default workflow"].ToString()))
						Response.Write(templatePair.Value.ID+"\t<B>" + templatePair.Value.FullName+ "</B>\t__Default workflow:\t"+stdItem.Fields["__Default workflow"]+"<BR>");
					/*
					
                    //templatePair.Value.GetFields(true).Where(f => f.Type == "Treelist")
                   foreach (var f in templatePair.Value.GetFields(true).Where(m => m.Name.ToLower().Contains("workflow"))
					)
                    {
					var locItem =  ItemManager.GetItem("{81CC0FB0-E6B8-44A2-869E-0011DA318891}",//templatePair.Value.StandardValueHolderId,
                       Sitecore.Globalization.Language.Parse(Sitecore.Configuration.Settings.DefaultLanguage),
                       Sitecore.Data.Version.First,
                        Database.GetDatabase("master"));
						
					Response.Write("Field:"+locItem.Fields[f.Name] + "<BR><BR>");
						
                       // if (!f.Source.Contains("core"))
                            //Response.Write(string.Format("Field [{0}] - {1} <BR>",f.Name , f.Source ));
                        Response.Write(string.Format(formatMsg,templatePair.Value.FullName,f.Name ,  f ));
                    }*/
					/* foreach (var f in stdItem.Fields//.Where(m => m.Name.ToLower().Contains("workflow")
					)
                    {
                       // if (!f.Source.Contains("core"))
                            //Response.Write(string.Format("Field [{0}] - {1} <BR>",f.Name , f.Source ));
                        Response.Write(string.Format(formatMsg,templatePair.Value.FullName,f ));
                    }*/
					

                }

                return duplicates;
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

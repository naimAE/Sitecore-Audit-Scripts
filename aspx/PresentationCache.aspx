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
            string[] multiList = {  "treelist" };


            using (new SecurityDisabler())
            {
                ItemManager.GetItem( Sitecore.Configuration.Settings.DefaultItem,Sitecore.Configuration.Settings.DefaultLanguage, Sitecore.Configuration.Settings.default
                      Database.GetDatabase("master"));
                    TemplateDictionary dict = TemplateManager.GetTemplates(Database.GetDatabase("master"));

                List<string> duplicates = new List<string>();

                string reportLine = "Field '{1}' duplicated from templates '{2}'";
                string formatMsg = "Template {0}: Field Name {1}, Type {2} , Source {3}<BR>";
                foreach (KeyValuePair<ID, Template> templatePair in dict)
                {
                    //templatePair.Value.GetFields(true).Where(f => f.Type == "Treelist")
                    foreach ( Sitecore.Data.Templates.TemplateField f in templatePair.Value.GetFields(true).Where(m=> multiList.Contains(m.TypeKey) && !Field.IsStandardTempalteField(m)))
                    {
                        if (!f.Source.Contains("core"))
                            Response.Write(string.Format("Field [{0}] - {1} <BR>",f.Name , f.Source ));
                        //Response.Write(string.Format(formatMsg,templatePair.Value.FullName,f.Name, f.Type, f.Source));
                    }

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

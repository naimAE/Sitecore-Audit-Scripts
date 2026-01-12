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
    public void Page_Load(object sender, EventArgs e)
    {
      //hello, world!
		var d= GetDuplicatesFields();
        Response.Write("Duplicates Fields Found :"+d.Count.ToString()+"<BR>");
		
		foreach (var item in d)
		{
			Response.Write(item.ToString()+"<BR>");
		}
    }
	
	public static List<string> GetDuplicatesFields()
    {
        using (new SecurityDisabler())
        {
           TemplateDictionary dict = TemplateManager.GetTemplates(Database.GetDatabase("master"));

			List<string> duplicates = new List<string>();

			string reportLine = "Field '{1}' duplicated from templates '{2}'";

			foreach (KeyValuePair<ID, Template> templatePair in dict)
			{
				foreach (IGrouping<string, Sitecore.Data.Templates.TemplateField> grouping in templatePair.Value.GetFields(true).GroupBy(f => f.Key).Where(f => f.Count() > 1))
				{
					duplicates.Add(String.Format(reportLine, templatePair.Value.FullName, grouping.Key, String.Join(", ", grouping.Select(g => g.Template.FullName))));
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

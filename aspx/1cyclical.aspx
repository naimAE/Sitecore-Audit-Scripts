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
        Response.Write("Hi<BR>");
		var d = CyclicallyInheritedTemplates();
        Response.Write("Cyclically Templates Found :"+d.Count.ToString()+"<BR>");
		
		foreach (var item in d)
		{
			Response.Write(string.Format("Template [{0}]:{1}<BR>",item.Part1,item.Part2));
		}
    }
	
	  public static List<Pair<string, string>> CyclicallyInheritedTemplates()
    {
        using (new SecurityDisabler())
        {
            var templates = TemplateManager.GetTemplates(Database.GetDatabase("master"));
            // var templates = TemplateManager.GetMasterTemplates();
            var resultPairs = new List<Pair<string, string>>();

            foreach (var template in templates)
            {
                resultPairs = CheckInBaseTemplates(resultPairs, template.Key.ToString(), template.Key.ToString(), string.Empty);
            }

            return resultPairs.ToList();
        }
    }

    private static List<Pair<string, string>> CheckInBaseTemplates(List<Pair<string, string>> result, string currentTemplatePath, string templateInitiator, string inheritanceChain)
    {
        var templateItem = TemplateManager.GetTemplate(currentTemplatePath, Database.GetDatabase("master"));
        var templateInitiatorItem = TemplateManager.GetTemplate(templateInitiator, Database.GetDatabase("master"));

        if (templateItem != null)
        {
            var inheritanceChainUpdated = string.Format("{0} <-- {1}", inheritanceChain, templateItem.Name);
           
			var foundMatches = templateItem.BaseIDs.Where(t => t.ToString().Equals(templateInitiator, StringComparison.InvariantCultureIgnoreCase) 
                                //&& !t.ID.ToString().Equals(templateItem.ID.ToString(), StringComparison.InvariantCultureIgnoreCase)
                                )
                                 .Select(t => new Pair<string, string>(templateInitiatorItem.FullName, string.Format("{0} <-- {1}", inheritanceChainUpdated, templateInitiatorItem.Name)));

            if (foundMatches.Any())
            {
                result.Add(foundMatches.FirstOrDefault());
            }

            foreach (var baseTemplate in templateItem.BaseIDs)
            {
                // Check in order to get rid of infinity recursion
                if (baseTemplate.ToString().Equals(templateInitiator))
                {
                    continue;
                }

                result = CheckInBaseTemplates(result, baseTemplate.ToString(), templateInitiator, inheritanceChainUpdated);
            }
        }

        return result;
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

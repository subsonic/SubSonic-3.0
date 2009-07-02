<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<Blog.Post>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Create
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
<link type="text/css" href="/scripts/ui-lightness/jquery-ui-1.7.1.custom.css" rel="stylesheet" />
<script type="text/javascript" src="/scripts/jquery-1.3.2.min.js"></script>
<script type="text/javascript" src="/scripts/jquery-ui-1.7.1.min.js"></script>
<script type="text/javascript">
    $(function() {
        $(".datepicker").datepicker();
    });
</script>

    <h2>Create</h2>

    <%= Html.ValidationSummary("Create was unsuccessful. Please correct the errors and try again.") %>

    <% using (Html.BeginForm()) {%>

        <fieldset>
            <legend>Fields</legend>
            <p>
                <label for="CategoryID">CategoryID:</label>
                
                <%=Html.DropDownList("CategoryID",new SelectList(Blog.Category.All(), "categoryid", "description")) %>
            </p>
            <p>
                <label for="Title">Title:</label>
                <%= Html.TextBox("Title") %>
                <%= Html.ValidationMessage("Title", "*") %>
            </p>
            <p>
                <label for="Slug">Slug:</label>
                <%= Html.TextBox("Slug") %>
                <%= Html.ValidationMessage("Slug", "*") %>
            </p>
            <p>
                <label for="Body">Body:</label>
                <%= Html.TextArea("Body", new {Style="width:70%;height:250px"}) %>
                <%= Html.ValidationMessage("Body", "*") %>
            </p>
            <p>
                <label for="PublishedOn">Publish On:</label>
                <%= Html.TextBox("PublishedOn", DateTime.Now, new { @class = "datepicker" })%>
                <%= Html.ValidationMessage("PublishedOn", "*") %>
            </p>
            <p>
                <input type="submit" value="Create" />
            </p>
        </fieldset>

    <% } %>

    <div>
        <%=Html.ActionLink("Back to List", "Index") %>
    </div>

</asp:Content>


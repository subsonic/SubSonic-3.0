<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<Blog.Post>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Edit
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

    <h2>Edit</h2>

    <%= Html.ValidationSummary("Edit was unsuccessful. Please correct the errors and try again.") %>

    <% using (Html.BeginForm()) {%>

        <fieldset>
            <legend>Fields</legend>
            <p>
                <%=Model.PostID %>
            </p>
            <p>
                <label for="CategoryID">CategoryID:</label>
                <%=Html.DropDownList("CategoryID") %>
            </p>
            <p>
                <label for="Title">Title:</label>
                <%= Html.TextBox("Title", Model.Title) %>
                <%= Html.ValidationMessage("Title", "*") %>
            </p>
            <p>
                <label for="Slug">Slug:</label>
                <%= Html.TextBox("Slug", Model.Slug) %>
                <%= Html.ValidationMessage("Slug", "*") %>
            </p>
            <p>
                <label for="Body">Body:</label>
                <%= Html.TextArea("Body",Model.Body, new {Style="width:70%;height:250px"}) %>
                <%= Html.ValidationMessage("Body", "*") %>
            </p>
            <p>
                <label for="PublishedOn">PublishedOn:</label>
                <%= Html.TextBox("PublishedOn", Model.PublishedOn, new { @class = "datepicker" })%>
                <%= Html.ValidationMessage("PublishedOn", "*") %>
            </p>
            <p>
                <input type="submit" value="Save" />
            </p>
        </fieldset>

    <% } %>

    <div>
        <%=Html.ActionLink("Back to List", "Index") %>
    </div>

</asp:Content>


<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<Blog.Post>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Details
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <h2>Details</h2>

    <fieldset>
        <legend>Fields</legend>
        <p>
            PostID:
            <%= Html.Encode(Model.PostID) %>
        </p>
        <p>
            CategoryID:
            <%= Html.Encode(Model.CategoryID) %>
        </p>
        <p>
            Title:
            <%= Html.Encode(Model.Title) %>
        </p>
        <p>
            Slug:
            <%= Html.Encode(Model.Slug) %>
        </p>
        <p>
            Body:
            <%= Html.Encode(Model.Body) %>
        </p>
        <p>
            PublishedOn:
            <%= Html.Encode(String.Format("{0:g}", Model.PublishedOn)) %>
        </p>
        <p>
            CreatedOn:
            <%= Html.Encode(String.Format("{0:g}", Model.CreatedOn)) %>
        </p>
        <p>
            ModifiedOn:
            <%= Html.Encode(String.Format("{0:g}", Model.ModifiedOn)) %>
        </p>
        <p>
            CreatedBy:
            <%= Html.Encode(Model.CreatedBy) %>
        </p>
        <p>
            ModifiedBy:
            <%= Html.Encode(Model.ModifiedBy) %>
        </p>
    </fieldset>
    <p>
        <%=Html.ActionLink("Edit", "Edit", new { /* id=Model.PrimaryKey */ }) %> |
        <%=Html.ActionLink("Back to List", "Index") %>
    </p>

</asp:Content>


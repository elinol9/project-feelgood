defmodule Feelgood.GuestbookTest do
  use Feelgood.DataCase

  alias Feelgood.Guestbook

  describe "comments" do
    alias Feelgood.Guestbook.Comment

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{}

    def comment_fixture(attrs \\ %{}) do
      {:ok, comment} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Guestbook.create_comment()

      comment
    end

    test "list_comments/0 returns all comments" do
      comment = comment_fixture()
      assert Guestbook.list_comments() == [comment]
    end

    test "get_comment!/1 returns the comment with given id" do
      comment = comment_fixture()
      assert Guestbook.get_comment!(comment.id) == comment
    end

    test "create_comment/1 with valid data creates a comment" do
      assert {:ok, %Comment{} = comment} = Guestbook.create_comment(@valid_attrs)
    end

    test "create_comment/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Guestbook.create_comment(@invalid_attrs)
    end

    test "update_comment/2 with valid data updates the comment" do
      comment = comment_fixture()
      assert {:ok, %Comment{} = comment} = Guestbook.update_comment(comment, @update_attrs)
    end

    test "update_comment/2 with invalid data returns error changeset" do
      comment = comment_fixture()
      assert {:error, %Ecto.Changeset{}} = Guestbook.update_comment(comment, @invalid_attrs)
      assert comment == Guestbook.get_comment!(comment.id)
    end

    test "delete_comment/1 deletes the comment" do
      comment = comment_fixture()
      assert {:ok, %Comment{}} = Guestbook.delete_comment(comment)
      assert_raise Ecto.NoResultsError, fn -> Guestbook.get_comment!(comment.id) end
    end

    test "change_comment/1 returns a comment changeset" do
      comment = comment_fixture()
      assert %Ecto.Changeset{} = Guestbook.change_comment(comment)
    end
  end

  describe "comments" do
    alias Feelgood.Guestbook.Comment

    @valid_attrs %{name: "some name", text: "some text"}
    @update_attrs %{name: "some updated name", text: "some updated text"}
    @invalid_attrs %{name: nil, text: nil}

    def comment_fixture(attrs \\ %{}) do
      {:ok, comment} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Guestbook.create_comment()

      comment
    end

    test "list_comments/0 returns all comments" do
      comment = comment_fixture()
      assert Guestbook.list_comments() == [comment]
    end

    test "get_comment!/1 returns the comment with given id" do
      comment = comment_fixture()
      assert Guestbook.get_comment!(comment.id) == comment
    end

    test "create_comment/1 with valid data creates a comment" do
      assert {:ok, %Comment{} = comment} = Guestbook.create_comment(@valid_attrs)
      assert comment.name == "some name"
      assert comment.text == "some text"
    end

    test "create_comment/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Guestbook.create_comment(@invalid_attrs)
    end

    test "update_comment/2 with valid data updates the comment" do
      comment = comment_fixture()
      assert {:ok, %Comment{} = comment} = Guestbook.update_comment(comment, @update_attrs)
      assert comment.name == "some updated name"
      assert comment.text == "some updated text"
    end

    test "update_comment/2 with invalid data returns error changeset" do
      comment = comment_fixture()
      assert {:error, %Ecto.Changeset{}} = Guestbook.update_comment(comment, @invalid_attrs)
      assert comment == Guestbook.get_comment!(comment.id)
    end

    test "delete_comment/1 deletes the comment" do
      comment = comment_fixture()
      assert {:ok, %Comment{}} = Guestbook.delete_comment(comment)
      assert_raise Ecto.NoResultsError, fn -> Guestbook.get_comment!(comment.id) end
    end

    test "change_comment/1 returns a comment changeset" do
      comment = comment_fixture()
      assert %Ecto.Changeset{} = Guestbook.change_comment(comment)
    end
  end
end

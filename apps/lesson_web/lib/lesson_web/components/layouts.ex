defmodule LessonWeb.Layouts do
  use LessonWeb, :html

  embed_templates "layouts/*"

  defp lnb(assigns) do
    ~H"""
    <nav class="w-40 min-h-screen shadow-lg bg-slate-50">
      <ul class="m-2 p-1 border-b">
        <span class="text-xl"><%= gettext("계정 관리") %></span>
        <li class="ml-2 m-1 text-sm bg-slate-100 border border-slate-400 shadow">
          <.link patch={~p"/admin/account/joining_request"} class="p-1 block w-full h-full">
            <%= gettext("가입 요청 확인") %>
          </.link>
        </li>
        <li class="ml-2 m-1 text-sm bg-slate-100 border border-slate-400 shadow">
          <.link patch={~p"/admin/account/creating"} class="p-1 block w-full h-full">
            <%= gettext("계정 생성") %>
          </.link>
        </li>
        <li class="ml-2 m-1 text-sm bg-slate-100 border border-slate-400 shadow">
          <.link patch={~p"/admin/account/editing"} class="p-1 block w-full h-full">
            <%= gettext("계정 수정/삭제") %>
          </.link>
        </li>
      </ul>
      <ul class="m-2 p-1 border-b">
        <span class="text-xl"><%= gettext("일정 관리") %></span>
        <li class="ml-2 m-1 text-sm bg-slate-100 border border-slate-400 shadow">
          <.link patch={~p"/admin/schedule/editing"} class="p-1 block w-full h-full">
            <%= gettext("일정 변경") %>
          </.link>
        </li>
      </ul>
      <ul class="m-2 p-1 border-b">
        <span class="text-xl"><%= gettext("수업 관리") %></span>
        <li class="ml-2 m-1 text-sm bg-slate-100 border border-slate-400 shadow">
          <.link patch={~p"/admin/lesson/evaluating"} class="p-1 block w-full h-full">
            <%= gettext("수업 조회/평가") %>
          </.link>
        </li>
      </ul>
      <ul class="m-2 p-1 border-b">
        <span class="text-xl"><%= gettext("통계") %></span>
        <li class="ml-2 m-1 text-sm bg-slate-100 border border-slate-400 shadow">
          <.link patch={~p"/admin/statistic/teacher"} class="p-1 block w-full h-full">
            <%= gettext("선생님 통계") %>
          </.link>
        </li>
        <li class="ml-2 m-1 text-sm bg-slate-100 border border-slate-400 shadow">
          <.link patch={~p"/admin/statistic/student"} class="p-1 block w-full h-full">
            <%= gettext("학생 통계") %>
          </.link>
        </li>
      </ul>
    </nav>
    """
  end
end

<master>
<property name="title">#file-storage.Upload_New_File#</property>
<property name="context">@context;noquote@</property>

<form enctype="multipart/form-data" method="POST" action="file-add-2" name="upload">
<input type=hidden name="folder_id" value="@folder_id@">

<table border=0>

<tr>
  <td align=right>#file-storage.Version_filename_# </td>
  <td><input type=file name=upload_file size=20></tr>
</tr>

<tr>
  <td>&nbsp;</td>
  <td>
    <img src="/shared/images/info.gif" width="12" height="9" alt="[i]" border="0">
    <font size=-1>#file-storage.lt_Use_the_Browse_button# </font>
  </td>
</tr>

<tr>
  <td>&nbsp;</td>
  <td>&nbsp;</td>
</tr>

<if @unpack_available_p@ true>
  <script language="JavaScript">
      function UnpackChanged(elm) {
        var form_name = "upload";

        if (elm == null) return;
        if (document.forms == null) return;
        if (document.forms[form_name] == null) return;

        if (elm.checked == true) {
            document.forms[form_name].elements["title"].disabled = true;
            document.forms[form_name].elements["title"].value = "";
        } else {
            document.forms[form_name].elements["title"].disabled = false;
        }
    }
  </script>

  <tr>
    <td align=right>#file-storage.Multiple_files#</td>
    <td>
      <input type="checkbox" name="unpack_p" value="t" id="unpack" onclick="javascript:UnpackChanged(this);">
      <label for="unpack">#file-storage.lt_This_is_a_ZIP#</label>
    </td>
  </tr>
</if>

<tr>
  <td align=right> #file-storage.Title# </td>
  <if @lock_title_p@ eq 0>
    <td>
      <input size=30 name=title value=@title@>
    </td>
  </if>
  <else>
      <input type=hidden name=title value=@title@>
      <td>@title@</td>
  </else>
</tr>

<tr>
  <td>&nbsp;</td>
  <td>
    <img src="/shared/images/info.gif" width="12" height="9" alt="[i]" border="0">
    <font color="red">#file-storage.lt_Leave_blank_for_linked_documents#</font>
  </td>
</tr>

<tr>
  <td valign=top align=right> #file-storage.Description# </td>
  <td colspan=2><textarea rows=5 cols=50 name=description wrap=physical></textarea></td>
</tr>

<tr>
<td></td>
<td><input type=submit value="#file-storage.Upload#">
</td>
</tr>

</table>
</form>

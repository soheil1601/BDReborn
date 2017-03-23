local function modadd(msg)
  local hash = "gp_lang:"..msg.to.id
  local lang = redis:get(hash)
  -- superuser and admins only (because sudo are always has privilege)
  if not is_admin(msg) then
    if not lang then
      return '🔴 *You are not bot admin*'
    else
      return 'شما مدیر ربات نمیباشید'
    end
  end
  local data = load_data(_config.moderation.data)
  if data[tostring(msg.to.id)] then
    if not lang then
      return '🔴 *Group is already added*'
    else
      return '🔴 گروه در لیست گروه های مدیریتی ربات هم اکنون موجود است'
    end
  end
  -- create data array in moderation.json
  data[tostring(msg.to.id)] = {
    owners = {},
    mods ={},
    banned ={},
    is_silent_users ={},
    filterlist ={},
    settings = {
      set_name = msg.to.title,
      lock_link = 'yes',
      lock_tag = 'yes',
      lock_spam = 'yes',
      lock_webpage = 'no',
      lock_markdown = 'no',
      flood = 'yes',
      lock_bots = 'yes',
      lock_pin = 'no',
      welcome = 'no',
    },
    mutes = {
      mute_fwd = 'no',
      mute_audio = 'no',
      mute_video = 'no',
      mute_contact = 'no',
      mute_text = 'no',
      mute_photos = 'no',
      mute_gif = 'no',
      mute_loc = 'no',
      mute_doc = 'no',
      mute_sticker = 'no',
      mute_voice = 'no',
      mute_all = 'no',
      mute_keyboard = 'no'
    }
  }
  save_data(_config.moderation.data, data)
  local groups = 'groups'
  if not data[tostring(groups)] then
    data[tostring(groups)] = {}
    save_data(_config.moderation.data, data)
  end
  data[tostring(groups)][tostring(msg.to.id)] = msg.to.id
  save_data(_config.moderation.data, data)
  if not lang then
    return '✅ *Group has been added*'
  else
    return '✅ گروه با موفقیت به لیست گروه های مدیریتی ربات افزوده شد'
  end
end

local function modrem(msg)
  local hash = "gp_lang:"..msg.to.id
  local lang = redis:get(hash)
  -- superuser and admins only (because sudo are always has privilege)
  if not is_admin(msg) then
    if not lang then
      return '🔴 *You are not bot admin*'
    else
      return 'شما مدیر ربات نمیباشید'
    end
  end
  local data = load_data(_config.moderation.data)
  local receiver = msg.to.id
  if not data[tostring(msg.to.id)] then
    if not lang then
      return '🔴 *Group is not added*'
    else
      return '🔴 گروه به لیست گروه های مدیریتی ربات اضافه نشده است'
    end
  end

  data[tostring(msg.to.id)] = nil
  save_data(_config.moderation.data, data)
  local groups = 'groups'
  if not data[tostring(groups)] then
    data[tostring(groups)] = nil
    save_data(_config.moderation.data, data)
    end data[tostring(groups)][tostring(msg.to.id)] = nil
    save_data(_config.moderation.data, data)
    if not lang then
      return '✅ *Group has been removed*'
    else
      return '✅ گروه با موفیت از لیست گروه های مدیریتی ربات حذف شد'
    end
  end

  local function filter_word(msg, word)
    local hash = "gp_lang:"..msg.to.id
    local lang = redis:get(hash)
    local data = load_data(_config.moderation.data)
    if not data[tostring(msg.to.id)]['filterlist'] then
      data[tostring(msg.to.id)]['filterlist'] = {}
      save_data(_config.moderation.data, data)
    end
    if data[tostring(msg.to.id)]['filterlist'][(word)] then
      if not lang then
        return "🔴 *Word* `"..word.."` *is already filtered*"
      else
        return "✅ کلمه *"..word.."* از قبل فیلتر بود"
      end
    end
    data[tostring(msg.to.id)]['filterlist'][(word)] = true
    save_data(_config.moderation.data, data)
    if not lang then
      return "✅ *Word* `"..word.."` *added to filtered words list*"
    else
      return "✅ کلمه *"..word.."* به لیست کلمات فیلتر شده اضافه شد"
    end
  end

  local function unfilter_word(msg, word)
    local hash = "gp_lang:"..msg.to.id
    local lang = redis:get(hash)
    local data = load_data(_config.moderation.data)
    if not data[tostring(msg.to.id)]['filterlist'] then
      data[tostring(msg.to.id)]['filterlist'] = {}
      save_data(_config.moderation.data, data)
    end
    if data[tostring(msg.to.id)]['filterlist'][word] then
      data[tostring(msg.to.id)]['filterlist'][(word)] = nil
      save_data(_config.moderation.data, data)
      if not lang then
        return "✅ *Word* `"..word.."` *removed from filtered words list*"
      elseif lang then
        return " کلمه *"..word.."* از لیست کلمات فیلتر شده حذف شد"
      end
    else
      if not lang then
        return "🔴 *Word* `"..word.."` *is not filtered*"
      elseif lang then
        return "🔴 کلمه *"..word.."* از قبل فیلتر نبود"
      end
    end
  end

  local function modlist(msg)
    local hash = "gp_lang:"..msg.to.id
    local lang = redis:get(hash)
    local data = load_data(_config.moderation.data)
    local i = 1
    if not data[tostring(msg.chat_id_)] then
      if not lang then
        return "🔴 *Group is not added*-"
      else
        return "✅ گروه به لیست گروه های مدیریتی ربات اضافه نشده است"
      end
    end
    -- determine if table is empty
    if next(data[tostring(msg.to.id)]['mods']) == nil then --fix way
    if not lang then
      return "🔴 *No moderator in this group*"
    else
      return "🔴 در حال حاضر هیچ مدیری برای گروه انتخاب نشده است"
    end
  end
  if not lang then
    message = '💠 *List of moderators :*\n'
  else
    message = '💠 لیست مدیران گروه :\n'
  end
  for k,v in pairs(data[tostring(msg.to.id)]['mods'])
  do
    message = message ..i.. '- '..v..' [' ..k.. '] \n'
    i = i + 1
  end
  return message
end
local function config(msg)
  local hash = "gp_lang:"..msg.to.id
  local lang = redis:get(hash)
  local data = load_data(_config.moderation.data)
  local administration = load_data(_config.moderation.data)
  local i = 1
  function padmin(extra,result,success)
    if not data[tostring(msg.chat_id_)] then
      if not lang then
        message = "🔴 *Group is not added*"
      else
        message = "🔴 گروه به لیست گروه های مدیریتی ربات اضافه نشده است"
      end
    end
    function set(arg, data)
      if data.username_ then
        user_name = '@'..check_markdown(data.username_)
      else
        user_name = check_markdown(data.first_name_)
      end
      administration[tostring(msg.to.id)]['mods'][tostring(data.id_)] = user_name
      save_data(_config.moderation.data, administration)
    end
    local admins = result.members_
    for i=0 , #admins do
      tdcli.getUser(admins[i].user_id_,set)
    end
    if not lang then
      message = "✅ *All Moderators has been added to Moderators !*"
    else
      message = "✅ تمامی ادمین های گروه به لیست مدیران گروه اضافه شدند !"
    end
    tdcli.sendMessage(msg.to.id,msg.id_, 1,message, 1, "html")
  end
  tdcli.getChannelMembers(msg.to.id,0,'Administrators',200,padmin)
end
local function ownerlist(msg)
  local hash = "gp_lang:"..msg.to.id
  local lang = redis:get(hash)
  local data = load_data(_config.moderation.data)
  local i = 1
  if not data[tostring(msg.to.id)] then
    if not lang then
      return "🔴 *Group is not added*"
    else
      return "🔴 گروه به لیست گروه های مدیریتی ربات اضافه نشده است"
    end
  end
  -- determine if table is empty
  if next(data[tostring(msg.to.id)]['owners']) == nil then --fix way
  if not lang then
    return "🔴 *No owner in this group*"
  else
    return "🔴 در حال حاضر هیچ مالکی برای گروه انتخاب نشده است"
  end
end
if not lang then
  message = '💠 *List of moderators :*\n'
else
  message = '💠 لیست مالکین گروه :\n'
end
for k,v in pairs(data[tostring(msg.to.id)]['owners']) do
  message = message ..i.. '- '..v..' [' ..k.. '] \n'
  i = i + 1
end
return message
end

local function action_by_reply(arg, data)
local hash = "gp_lang:"..data.chat_id_
local lang = redis:get(hash)
local cmd = arg.cmd
local administration = load_data(_config.moderation.data)
if not tonumber(data.sender_user_id_) then return false end
if data.sender_user_id_ then
  if not administration[tostring(data.chat_id_)] then
    if not lang then
      return tdcli.sendMessage(data.chat_id_, "", 0, "🔴 *Group is not added*", 0, "md")
    else
      return tdcli.sendMessage(data.chat_id_, "", 0, "🔴 گروه به لیست گروه های مدیریتی ربات اضافه نشده است", 0, "md")
    end
  end
  if cmd == "setowner" then
    local function owner_cb(arg, data)
      local hash = "gp_lang:"..arg.chat_id
      local lang = redis:get(hash)
      local administration = load_data(_config.moderation.data)
      if data.username_ then
        user_name = '@'..check_markdown(data.username_)
      else
        user_name = check_markdown(data.first_name_)
      end
      if administration[tostring(arg.chat_id)]['owners'][tostring(data.id_)] then
        if not lang then
          return tdcli.sendMessage(arg.chat_id, "", 0, "🔴 *User* "..user_name.." `["..data.id_.."]` *is already a group owner*", 0, "md")
        else
          return tdcli.sendMessage(arg.chat_id, "", 0, "🔴 کاربر "..user_name.." `["..data.id_.."]` *از قبل صاحب گروه بود*", 0, "md")
        end
      end
      administration[tostring(arg.chat_id)]['owners'][tostring(data.id_)] = user_name
      save_data(_config.moderation.data, administration)
      if not lang then
        return tdcli.sendMessage(arg.chat_id, "", 0, "✅ *User* "..user_name.." `["..data.id_.."]` *is now the group owner*", 0, "md")
      else
        return tdcli.sendMessage(arg.chat_id, "", 0, "✅ کاربر "..user_name.." `["..data.id_.."]` *به مقام صاحب گروه منتصب شد*", 0, "md")
      end
    end
    tdcli_function ({
      ID = "GetUser",
      user_id_ = data.sender_user_id_
    }, owner_cb, {chat_id=data.chat_id_,user_id=data.sender_user_id_})
  end
  if cmd == "promote" then
    local function promote_cb(arg, data)
      local hash = "gp_lang:"..arg.chat_id
      local lang = redis:get(hash)
      local administration = load_data(_config.moderation.data)
      if data.username_ then
        user_name = '@'..check_markdown(data.username_)
      else
        user_name = check_markdown(data.first_name_)
      end
      if administration[tostring(arg.chat_id)]['mods'][tostring(data.id_)] then
        if not lang then
          return tdcli.sendMessage(arg.chat_id, "", 0, "🔴 *User* "..user_name.." `["..data.id_.."]` *is already a moderator*", 0, "md")
        else
          return tdcli.sendMessage(arg.chat_id, "", 0, "🔴 کاربر "..user_name.." `["..data.id_.."]` *از قبل مدیر گروه بود*", 0, "md")
        end
      end
      administration[tostring(arg.chat_id)]['mods'][tostring(data.id_)] = user_name
      save_data(_config.moderation.data, administration)
      if not lang then
        return tdcli.sendMessage(arg.chat_id, "", 0, "✅ *User* "..user_name.." `["..data.id_.."]` *has been promoted*", 0, "md")
      else
        return tdcli.sendMessage(arg.chat_id, "", 0, "✅ کاربر "..user_name.." `["..data.id_.."]` *به مقام مدیر گروه منتصب شد*", 0, "md")
      end
    end
    tdcli_function ({
      ID = "GetUser",
      user_id_ = data.sender_user_id_
    }, promote_cb, {chat_id=data.chat_id_,user_id=data.sender_user_id_})
  end
  if cmd == "remowner" then
    local function rem_owner_cb(arg, data)
      local hash = "gp_lang:"..arg.chat_id
      local lang = redis:get(hash)
      local administration = load_data(_config.moderation.data)
      if data.username_ then
        user_name = '@'..check_markdown(data.username_)
      else
        user_name = check_markdown(data.first_name_)
      end
      if not administration[tostring(arg.chat_id)]['owners'][tostring(data.id_)] then
        if not lang then
          return tdcli.sendMessage(arg.chat_id, "", 0, "🔴 *User* "..user_name.." `["..data.id_.."]` *is not a group owner*", 0, "md")
        else
          return tdcli.sendMessage(arg.chat_id, "", 0, "🔴کاربر "..user_name.." `["..data.id_.."]` *از قبل صاحب گروه نبود*", 0, "md")
        end
      end
      administration[tostring(arg.chat_id)]['owners'][tostring(data.id_)] = nil
      save_data(_config.moderation.data, administration)
      if not lang then
        return tdcli.sendMessage(arg.chat_id, "", 0, "✅ *User* "..user_name.." `["..data.id_.."]` *is no longer a group owner*", 0, "md")
      else
        return tdcli.sendMessage(arg.chat_id, "", 0, "✅ کاربر "..user_name.." `["..data.id_.."]` *از مقام صاحب گروه برکنار شد*", 0, "md")
      end
    end
    tdcli_function ({
      ID = "GetUser",
      user_id_ = data.sender_user_id_
    }, rem_owner_cb, {chat_id=data.chat_id_,user_id=data.sender_user_id_})
  end
  if cmd == "demote" then
    local function demote_cb(arg, data)
      local administration = load_data(_config.moderation.data)
      if data.username_ then
        user_name = '@'..check_markdown(data.username_)
      else
        user_name = check_markdown(data.first_name_)
      end
      if not administration[tostring(arg.chat_id)]['mods'][tostring(data.id_)] then
        if not lang then
          return tdcli.sendMessage(arg.chat_id, "", 0, "🔴 *User* "..user_name.." `["..data.id_.."]` *is not a moderator*", 0, "md")
        else
          return tdcli.sendMessage(arg.chat_id, "", 0, "🔴 کاربر "..user_name.." `["..data.id_.."]` *از قبل مدیر گروه نبود*", 0, "md")
        end
      end
      administration[tostring(arg.chat_id)]['mods'][tostring(data.id_)] = nil
      save_data(_config.moderation.data, administration)
      if not lang then
        return tdcli.sendMessage(arg.chat_id, "", 0, "✅ *User* "..user_name.." `["..data.id_.."]` *has been demoted*", 0, "md")
      else
        return tdcli.sendMessage(arg.chat_id, "", 0, "✅ کاربر "..user_name.." `["..data.id_.."]` *از مقام مدیر گروه برکنار شد*", 0, "md")
      end
    end
    tdcli_function ({
      ID = "GetUser",
      user_id_ = data.sender_user_id_
    }, demote_cb, {chat_id=data.chat_id_,user_id=data.sender_user_id_})
  end
  if cmd == "id" then
    local function id_cb(arg, data)
      return tdcli.sendMessage(arg.chat_id, "", 0, "`["..data.id_.."]`", 0, "md")
    end
    tdcli_function ({
      ID = "GetUser",
      user_id_ = data.sender_user_id_
    }, id_cb, {chat_id=data.chat_id_,user_id=data.sender_user_id_})
  end
else
  if lang then
    return tdcli.sendMessage(data.chat_id_, "", 0, "🔴 کاربر یافت نشد", 0, "md")
  else
    return tdcli.sendMessage(data.chat_id_, "", 0, "🔴 *User Not Found*", 0, "md")
  end
end
end

local function action_by_username(arg, data)
local hash = "gp_lang:"..arg.chat_id
local lang = redis:get(hash)
local cmd = arg.cmd
local administration = load_data(_config.moderation.data)
if not administration[tostring(arg.chat_id)] then
  if not lang then
    return tdcli.sendMessage(data.chat_id_, "", 0, "🔴 *Group is not added*", 0, "md")
  else
    return tdcli.sendMessage(data.chat_id_, "", 0, "🔴 گروه به لیست گروه های مدیریتی ربات اضافه نشده است", 0, "md")
  end
end
if not arg.username then return false end
if data.id_ then
  if data.type_.user_.username_ then
    user_name = '@'..check_markdown(data.type_.user_.username_)
  else
    user_name = check_markdown(data.title_)
  end
  if cmd == "setowner" then
    if administration[tostring(arg.chat_id)]['owners'][tostring(data.id_)] then
      if not lang then
        return tdcli.sendMessage(arg.chat_id, "", 0, "🔴 *User* "..user_name.." `["..data.id_.."]` *is already a group owner*", 0, "md")
      else
        return tdcli.sendMessage(arg.chat_id, "", 0, "🔴 کاربر "..user_name.." `["..data.id_.."]` *از قبل صاحب گروه بود*", 0, "md")
      end
    end
    administration[tostring(arg.chat_id)]['owners'][tostring(data.id_)] = user_name
    save_data(_config.moderation.data, administration)
    if not lang then
      return tdcli.sendMessage(arg.chat_id, "", 0, "🔴 *User* "..user_name.." `["..data.id_.."]` *is now the group owner*", 0, "md")
    else
      return tdcli.sendMessage(arg.chat_id, "", 0, "🔴 کاربر "..user_name.." `["..data.id_.."]` *به مقام صاحب گروه منتصب شد*", 0, "md")
    end
  end
  if cmd == "promote" then
    if administration[tostring(arg.chat_id)]['mods'][tostring(data.id_)] then
      if not lang then
        return tdcli.sendMessage(arg.chat_id, "", 0, "🔴 *User*  "..user_name.." `["..data.id_.."]` *is already a moderator*", 0, "md")
      else
        return tdcli.sendMessage(arg.chat_id, "", 0, "🔴 کاربر "..user_name.." `["..data.id_.."]` *از قبل مدیر گروه بود*", 0, "md")
      end
    end
    administration[tostring(arg.chat_id)]['mods'][tostring(data.id_)] = user_name
    save_data(_config.moderation.data, administration)
    if not lang then
      return tdcli.sendMessage(arg.chat_id, "", 0, "✅ *User*  "..user_name.." `["..data.id_.."]` *has been promoted*", 0, "md")
    else
      return tdcli.sendMessage(arg.chat_id, "", 0, "✅ کاربر "..user_name.." `["..data.id_.."]` *به مقام مدیر گروه منتصب شد*", 0, "md")
    end
  end
  if cmd == "remowner" then
    if not administration[tostring(arg.chat_id)]['owners'][tostring(data.id_)] then
      if not lang then
        return tdcli.sendMessage(arg.chat_id, "", 0, "🔴 *User*  "..user_name.." `["..data.id_.."]` *is not a group owner*", 0, "md")
      else
        return tdcli.sendMessage(arg.chat_id, "", 0, "🔴 کاربر  "..user_name.." `["..data.id_.."]` *از قبل صاحب گروه نبود*", 0, "md")
      end
    end
    administration[tostring(arg.chat_id)]['owners'][tostring(data.id_)] = nil
    save_data(_config.moderation.data, administration)
    if not lang then
      return tdcli.sendMessage(arg.chat_id, "", 0, "✅ *User*  "..user_name.." `["..data.id_.."]` *is no longer a group owner*", 0, "md")
    else
      return tdcli.sendMessage(arg.chat_id, "", 0, "✅ کاربر "..user_name.." `["..data.id_.."]` *از مقام صاحب گروه برکنار شد*", 0, "md")
    end
  end
  if cmd == "demote" then
    if not administration[tostring(arg.chat_id)]['mods'][tostring(data.id_)] then
      if not lang then
        return tdcli.sendMessage(arg.chat_id, "", 0, "🔴 *User*  "..user_name.." `["..data.id_.."]` *is not a moderator*", 0, "md")
      else
        return tdcli.sendMessage(arg.chat_id, "", 0, "🔴 کاربر "..user_name.." `["..data.id_.."]` *از قبل مدیر گروه نبود*", 0, "md")
      end
    end
    administration[tostring(arg.chat_id)]['mods'][tostring(data.id_)] = nil
    save_data(_config.moderation.data, administration)
    if not lang then
      return tdcli.sendMessage(arg.chat_id, "", 0, "✅ *User*  "..user_name.." `["..data.id_.."]` *has been demoted*", 0, "md")
    else
      return tdcli.sendMessage(arg.chat_id, "", 0, "🔴 کاربر "..user_name.." `["..data.id_.."]` *از مقام مدیر گروه برکنار شد*", 0, "md")
    end
  end
  if cmd == "id" then
    return tdcli.sendMessage(arg.chat_id, "", 0, "`["..data.id_.."]`", 0, "md")
  end
  if cmd == "res" then
    if not lang then
      text = "💠 Result for [ "..check_markdown(data.type_.user_.username_).." ] :\n"
      .. ""..check_markdown(data.title_).."\n"
      .. " ["..data.id_.."]"
    else
      text = "💠 اطلاعات برای [ "..check_markdown(data.type_.user_.username_).." ] :\n"
      .. "".. check_markdown(data.title_) .."\n"
      .. " [".. data.id_ .."]"
    end
    return tdcli.sendMessage(arg.chat_id, 0, 1, text, 1, 'md')
  end
else
  if lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "🔴 کاربر یافت نشد", 0, "md")
  else
    return tdcli.sendMessage(arg.chat_id, "", 0, "🔴 *User Not Found*", 0, "md")
  end
end
end

local function action_by_id(arg, data)
local hash = "gp_lang:"..arg.chat_id
local lang = redis:get(hash)
local cmd = arg.cmd
local administration = load_data(_config.moderation.data)
if not administration[tostring(arg.chat_id)] then
  if not lang then
    return tdcli.sendMessage(data.chat_id_, "", 0, "🔴 *Group is not added*", 0, "md")
  else
    return tdcli.sendMessage(data.chat_id_, "", 0, "🔴 گروه به لیست گروه های مدیریتی ربات اضافه نشده است", 0, "md")
  end
end
if not tonumber(arg.user_id) then return false end
if data.id_ then
  if data.first_name_ then
    if data.username_ then
      user_name = '@'..check_markdown(data.username_)
    else
      user_name = check_markdown(data.first_name_)
    end
    if cmd == "setowner" then
      if administration[tostring(arg.chat_id)]['owners'][tostring(data.id_)] then
        if not lang then
          return tdcli.sendMessage(arg.chat_id, "", 0, "🔴 *User*  "..user_name.." `["..data.id_.."]` *is already a group owner*", 0, "md")
        else
          return tdcli.sendMessage(arg.chat_id, "", 0, "🔴 کاربر "..user_name.." `["..data.id_.."]` *از قبل صاحب گروه بود*", 0, "md")
        end
      end
      administration[tostring(arg.chat_id)]['owners'][tostring(data.id_)] = user_name
      save_data(_config.moderation.data, administration)
      if not lang then
        return tdcli.sendMessage(arg.chat_id, "", 0, "✅ *User*  "..user_name.." `["..data.id_.."]` *is now the group owner*", 0, "md")
      else
        return tdcli.sendMessage(arg.chat_id, "", 0, "🔴 کاربر "..user_name.." `["..data.id_.."]` *به مقام صاحب گروه منتصب شد*", 0, "md")
      end
    end
    if cmd == "promote" then
      if administration[tostring(arg.chat_id)]['mods'][tostring(data.id_)] then
        if not lang then
          return tdcli.sendMessage(arg.chat_id, "", 0, "🔴 *User*  "..user_name.." `["..data.id_.."]` *is already a moderator*", 0, "md")
        else
          return tdcli.sendMessage(arg.chat_id, "", 0, "🔴 کاربر "..user_name.." `["..data.id_.."]` *از قبل مدیر گروه بود*", 0, "md")
        end
      end
      administration[tostring(arg.chat_id)]['mods'][tostring(data.id_)] = user_name
      save_data(_config.moderation.data, administration)
      if not lang then
        return tdcli.sendMessage(arg.chat_id, "", 0, "✅ *User*  "..user_name.." `["..data.id_.."]` *has been promoted*", 0, "md")
      else
        return tdcli.sendMessage(arg.chat_id, "", 0, "🔴 کاربر "..user_name.." `["..data.id_.."]` *به مقام مدیر گروه منتصب شد*", 0, "md")
      end
    end
    if cmd == "remowner" then
      if not administration[tostring(arg.chat_id)]['owners'][tostring(data.id_)] then
        if not lang then
          return tdcli.sendMessage(arg.chat_id, "", 0, "🔴 *User*  "..user_name.." `["..data.id_.."]` *is not a group owner*", 0, "md")
        else
          return tdcli.sendMessage(arg.chat_id, "", 0, "🔴 کاربر  "..user_name.." `["..data.id_.."]` *از قبل صاحب گروه نبود*", 0, "md")
        end
      end
      administration[tostring(arg.chat_id)]['owners'][tostring(data.id_)] = nil
      save_data(_config.moderation.data, administration)
      if not lang then
        return tdcli.sendMessage(arg.chat_id, "", 0, "✅ *User*  "..user_name.." `["..data.id_.."]` *is no longer a group owner*", 0, "md")
      else
        return tdcli.sendMessage(arg.chat_id, "", 0, "✅ کاربر "..user_name.." `["..data.id_.."]` *از مقام صاحب گروه برکنار شد*", 0, "md")
      end
    end
    if cmd == "demote" then
      if not administration[tostring(arg.chat_id)]['mods'][tostring(data.id_)] then
        if not lang then
          return tdcli.sendMessage(arg.chat_id, "", 0, "🔴 *User*  "..user_name.." `["..data.id_.."]` *is not a moderator*", 0, "md")
        else
          return tdcli.sendMessage(arg.chat_id, "", 0, "🔴 کاربر "..user_name.." `["..data.id_.."]` *از قبل مدیر گروه نبود*", 0, "md")
        end
      end
      administration[tostring(arg.chat_id)]['mods'][tostring(data.id_)] = nil
      save_data(_config.moderation.data, administration)
      if not lang then
        return tdcli.sendMessage(arg.chat_id, "", 0, "✅ *User*  "..user_name.." `["..data.id_.."]` *has been demoted*", 0, "md")
      else
        return tdcli.sendMessage(arg.chat_id, "", 0, "✅ کاربر "..user_name.." `["..data.id_.."]` *از مقام مدیر گروه برکنار شد*", 0, "md")
      end
    end
    if cmd == "whois" then
      if data.username_ then
        username = '@'..check_markdown(data.username_)
      else
        if not lang then
          username = 'not found'
        else
          username = 'ندارد'
        end
      end
      if not lang then
        return tdcli.sendMessage(arg.chat_id, 0, 1, '💠 Info for `[ '..data.id_..' ]` :\n*UserName :* '..username..'\n*Name :* '..data.first_name_, 1)
      else
        return tdcli.sendMessage(arg.chat_id, 0, 1, '💠 اطلاعات برای `[ '..data.id_..' ]` :\nیوزرنیم : '..username..'\nنام : '..data.first_name_, 1)
      end
    end
  else
    if not lang then
      return tdcli.sendMessage(arg.chat_id, "", 0, "🔴 *User not found*", 0, "md")
    else
      return tdcli.sendMessage(arg.chat_id, "", 0, "🔴 کاربر یافت نشد", 0, "md")
    end
  end
else
  if lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "_🔴 کاربر یافت نشد", 0, "md")
  else
    return tdcli.sendMessage(arg.chat_id, "", 0, "🔴 *User Not Found*", 0, "md")
  end
end
end


---------------Lock Link-------------------
local function lock_link(msg, data, target)
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
if not is_mod(msg) then
  if not lang then
    return "⛔️ *You're Not Moderator*"
  else
    return "⛔️ شما مدیر گروه نمیباشید"
  end
end

local lock_link = data[tostring(target)]["settings"]["lock_link"]
if lock_link == "yes" then
  if not lang then
    return "🔴 *Link Posting Is Already Locked*"
  elseif lang then
    return "🔴 ارسال لینک در گروه هم اکنون ممنوع است"
  end
else
  data[tostring(target)]["settings"]["lock_link"] = "yes"
  save_data(_config.moderation.data, data)
  if not lang then
    return "✅ *Link Posting Has Been Locked*"
  else
    return "✅ ارسال لینک در گروه ممنوع شد"
  end
end
end

local function unlock_link(msg, data, target)
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
if not is_mod(msg) then
  if not lang then
    return "⛔️ *You're Not Moderator*"
  else
    return "⛔️ شما مدیر گروه نمیباشید"
  end
end

local lock_link = data[tostring(target)]["settings"]["lock_link"]
if lock_link == "no" then
  if not lang then
    return "🔴 *Link Posting Is Not Locked*"
  elseif lang then
    return "🔴 ارسال لینک در گروه ممنوع نمیباشد"
  end
else
  data[tostring(target)]["settings"]["lock_link"] = "no" save_data(_config.moderation.data, data)
  if not lang then
    return "✅ *Link Posting Has Been Unlocked*"
  else
    return "✅ ارسال لینک در گروه آزاد شد"
  end
end
end

---------------Lock Tag-------------------
local function lock_tag(msg, data, target)
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
if not is_mod(msg) then
  if not lang then
    return "⛔️ *You're Not Moderator*"
  else
    return "⛔️ شما مدیر گروه نمیباشید"
  end
end

local lock_tag = data[tostring(target)]["settings"]["lock_tag"]
if lock_tag == "yes" then
  if not lang then
    return "🔴 *Tag Posting Is Already Locked*"
  elseif lang then
    return "🔴 ارسال تگ در گروه هم اکنون ممنوع است"
  end
else
  data[tostring(target)]["settings"]["lock_tag"] = "yes"
  save_data(_config.moderation.data, data)
  if not lang then
    return "✅ *TagPosting Has Been Locked*"
  else
    return "✅ ارسال تگ در گروه ممنوع شد"
  end
end
end

local function unlock_tag(msg, data, target)
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
if not is_mod(msg) then
  if not lang then
    return "⛔️ *You're Not Moderator*"
  else
    return "⛔️ شما مدیر گروه نمیباشید"
  end
end

local lock_tag = data[tostring(target)]["settings"]["lock_tag"]
if lock_tag == "no" then
  if not lang then
    return "🔴 *Tag Posting Is Not Locked*"
  elseif lang then
    return "🔴 ارسال تگ در گروه ممنوع نمیباشد"
  end
else
  data[tostring(target)]["settings"]["lock_tag"] = "no" save_data(_config.moderation.data, data)
  if not lang then
    return "✅ *Tag Posting Has Been Unlocked*"
  else
    return "✅ ارسال تگ در گروه آزاد شد"
  end
end
end

---------------Lock Mention-------------------
local function lock_mention(msg, data, target)
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
if not is_mod(msg) then
  if not lang then
    return "⛔️ *You're Not Moderator*"
  else
    return "⛔️ شما مدیر گروه نمیباشید"
  end
end

local lock_mention = data[tostring(target)]["settings"]["lock_mention"]
if lock_mention == "yes" then
  if not lang then
    return "🔴 *Mention Posting Is Already Locked*"
  elseif lang then
    return "🔴 ارسال فراخوانی افراد هم اکنون ممنوع است"
  end
else
  data[tostring(target)]["settings"]["lock_mention"] = "yes"
  save_data(_config.moderation.data, data)
  if not lang then
    return "✅ *Mention Posting Has Been Locked*"
  else
    return "✅ ارسال فراخوانی افراد در گروه ممنوع شد"
  end
end
end

local function unlock_mention(msg, data, target)
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
if not is_mod(msg) then
  if not lang then
    return "⛔️ *You're Not Moderator*"
  else
    return "⛔️ شما مدیر گروه نمیباشید"
  end
end

local lock_mention = data[tostring(target)]["settings"]["lock_mention"]
if lock_mention == "no" then
  if not lang then
    return "🔴 *Mention Posting Is Not Locked*"
  elseif lang then
    return "🔴 ارسال فراخوانی افراد در گروه ممنوع نمیباشد"
  end
else
  data[tostring(target)]["settings"]["lock_mention"] = "no" save_data(_config.moderation.data, data)
  if not lang then
    return "✅ *Mention Posting Has Been Unlocked*"
  else
    return "✅ ارسال فراخوانی افراد در گروه آزاد شد"
  end
end
end

---------------Lock Arabic--------------
local function lock_arabic(msg, data, target)
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
if not is_mod(msg) then
  if not lang then
    return "⛔️ *You're Not Moderator*"
  else
    return "⛔️ شما مدیر گروه نمیباشید"
  end
end

local lock_arabic = data[tostring(target)]["settings"]["lock_arabic"]
if lock_arabic == "yes" then
  if not lang then
    return "🔴 *Arabic/Persian Posting Is Already Locked*"
  elseif lang then
    return "🔴 ارسال کلمات عربی/فارسی در گروه هم اکنون ممنوع است"
  end
else
  data[tostring(target)]["settings"]["lock_arabic"] = "yes"
  save_data(_config.moderation.data, data)
  if not lang then
    return "✅ *Arabic/Persian Posting Has Been Locked*"
  else
    return "✅ *ارسال کلمات عربی/فارسی در گروه ممنوع شد"
  end
end
end

local function unlock_arabic(msg, data, target)
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
if not is_mod(msg) then
  if not lang then
    return "⛔️ *You're Not Moderator*"
  else
    return "⛔️ شما مدیر گروه نمیباشید"
  end
end

local lock_arabic = data[tostring(target)]["settings"]["lock_arabic"]
if lock_arabic == "no" then
  if not lang then
    return "🔴 *Arabic/Persian Posting Is Not Locked*"
  elseif lang then
    return "ارسال کلمات عربی/فارسی در گروه ممنوع نمیباشد"
  end
else
  data[tostring(target)]["settings"]["lock_arabic"] = "no" save_data(_config.moderation.data, data)
  if not lang then
    return "✅ *Arabic/Persian Posting Has Been Unlocked*"
  else
    return "ارسال کلمات عربی/فارسی در گروه آزاد شد"
  end
end
end

---------------Lock Edit-------------------
local function lock_edit(msg, data, target)
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
if not is_mod(msg) then
  if not lang then
    return "⛔️ *You're Not Moderator*"
  else
    return "⛔️ شما مدیر گروه نمیباشید"
  end
end

local lock_edit = data[tostring(target)]["settings"]["lock_edit"]
if lock_edit == "yes" then
  if not lang then
    return "🔴 *Editing Is Already Locked*"
  elseif lang then
    return "ویرایش پیام هم اکنون ممنوع است"
  end
else
  data[tostring(target)]["settings"]["lock_edit"] = "yes"
  save_data(_config.moderation.data, data)
  if not lang then
    return "✅*Editing Has Been Locked*"
  else
    return "ویرایش پیام در گروه ممنوع شد"
  end
end
end

local function unlock_edit(msg, data, target)
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
if not is_mod(msg) then
  if not lang then
    return "⛔️ *You're Not Moderator*"
  else
    return "⛔️ شما مدیر گروه نمیباشید"
  end
end

local lock_edit = data[tostring(target)]["settings"]["lock_edit"]
if lock_edit == "no" then
  if not lang then
    return "🔴 *Editing Is Not Locked*"
  elseif lang then
    return "ویرایش پیام در گروه ممنوع نمیباشد"
  end
else
  data[tostring(target)]["settings"]["lock_edit"] = "no" save_data(_config.moderation.data, data)
  if not lang then
    return "✅ *Editing Has Been Unlocked*"
  else
    return "ویرایش پیام در گروه آزاد شد"
  end
end
end

---------------Lock spam-------------------
local function lock_spam(msg, data, target)
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
if not is_mod(msg) then
  if not lang then
    return "⛔️ *You're Not Moderator*"
  else
    return "⛔️ شما مدیر گروه نمیباشید"
  end
end

local lock_spam = data[tostring(target)]["settings"]["lock_spam"]
if lock_spam == "yes" then
  if not lang then
    return "🔴 *Spam Is Already Locked*"
  elseif lang then
    return "ارسال هرزنامه در گروه هم اکنون ممنوع است"
  end
else
  data[tostring(target)]["settings"]["lock_spam"] = "yes"
  save_data(_config.moderation.data, data)
  if not lang then
    return "✅ *Spam Has Been Locked*"
  else
    return "ارسال هرزنامه در گروه ممنوع شد"
  end
end
end

local function unlock_spam(msg, data, target)
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
if not is_mod(msg) then
  if not lang then
    return "⛔️ *You're Not Moderator*"
  else
    return "⛔️ شما مدیر گروه نمیباشید"
  end
end

local lock_spam = data[tostring(target)]["settings"]["lock_spam"]
if lock_spam == "no" then
  if not lang then
    return "🔴 *Spam Posting Is Not Locked*"
  elseif lang then
    return "ارسال هرزنامه در گروه ممنوع نمیباشد"
  end
else
  data[tostring(target)]["settings"]["lock_spam"] = "no"
  save_data(_config.moderation.data, data)
  if not lang then
    return "✅ *Spam Posting Has Been Unlocked*"
  else
    return "ارسال هرزنامه در گروه آزاد شد"
  end
end
end

---------------Lock Flood-------------------
local function lock_flood(msg, data, target)
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
if not is_mod(msg) then
  if not lang then
    return "⛔️ *You're Not Moderator*"
  else
    return "⛔️ شما مدیر گروه نمیباشید"
  end
end

local lock_flood = data[tostring(target)]["settings"]["flood"]
if lock_flood == "yes" then
  if not lang then
    return "🔴 *Flooding Is Already Locked*"
  elseif lang then
    return "ارسال پیام مکرر در گروه هم اکنون ممنوع است"
  end
else
  data[tostring(target)]["settings"]["flood"] = "yes"
  save_data(_config.moderation.data, data)
  if not lang then
    return "✅ Flooding Has Been Locked*"
  else
    return "ارسال پیام مکرر در گروه ممنوع شد"
  end
end
end

local function unlock_flood(msg, data, target)
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
if not is_mod(msg) then
  if not lang then
    return "⛔️ *You're Not Moderator*"
  else
    return "⛔️ شما مدیر گروه نمیباشید"
  end
end

local lock_flood = data[tostring(target)]["settings"]["flood"]
if lock_flood == "no" then
  if not lang then
    return "🔴 *Flooding Is Not Locked*"
  elseif lang then
    return "ارسال پیام مکرر در گروه ممنوع نمیباشد"
  end
else
  data[tostring(target)]["settings"]["flood"] = "no" save_data(_config.moderation.data, data)
  if not lang then
    return "✅ *Flooding Has Been Unlocked*"
  else
    return "ارسال پیام مکرر در گروه آزاد شد"
  end
end
end

---------------Lock Bots-------------------
local function lock_bots(msg, data, target)
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
if not is_mod(msg) then
  if not lang then
    return "⛔️ *You're Not Moderator*"
  else
    return "⛔️ شما مدیر گروه نمیباشید"
  end
end

local lock_bots = data[tostring(target)]["settings"]["lock_bots"]
if lock_bots == "yes" then
  if not lang then
    return "🔴 *Bots Protection Is Already Enabled*"
  elseif lang then
    return "محافظت از گروه در برابر ربات ها هم اکنون فعال است"
  end
else
  data[tostring(target)]["settings"]["lock_bots"] = "yes"
  save_data(_config.moderation.data, data)
  if not lang then
    return "✅ *Bots Protection Has Been Enabled*"
  else
    return "محافظت از گروه در برابر ربات ها فعال شد"
  end
end
end

local function unlock_bots(msg, data, target)
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
if not is_mod(msg) then
  if not lang then
    return "⛔️ *You're Not Moderator*"
  else
    return "⛔️ شما مدیر گروه نمیباشید"
  end
end

local lock_bots = data[tostring(target)]["settings"]["lock_bots"]
if lock_bots == "no" then
  if not lang then
    return "🔴 *Bots Protection Is Not Enabled*"
  elseif lang then
    return "محافظت از گروه در برابر ربات ها غیر فعال است"
  end
else
  data[tostring(target)]["settings"]["lock_bots"] = "no" save_data(_config.moderation.data, data)
  if not lang then
    return "✅ *Bots Protection Has Been Disabled*"
  else
    return "محافظت از گروه در برابر ربات ها غیر فعال شد"
  end
end
end

---------------Lock Markdown-------------------
local function lock_markdown(msg, data, target)
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
if not is_mod(msg) then
  if not lang then
    return "⛔️ *You're Not Moderator*"
  else
    return "⛔️ شما مدیر گروه نمیباشید"
  end
end

local lock_markdown = data[tostring(target)]["settings"]["lock_markdown"]
if lock_markdown == "yes" then
  if not lang then
    return "🔴 *Markdown Posting Is Already Locked*"
  elseif lang then
    return "🔴 ارسال پیام های دارای فونت در گروه هم اکنون ممنوع است"
  end
else
  data[tostring(target)]["settings"]["lock_markdown"] = "yes"
  save_data(_config.moderation.data, data)
  if not lang then
    return "✅ *Markdown Posting Has Been Locked*"
  else
    return "✅ رسال پیام های دارای فونت در گروه ممنوع شد"
  end
end
end

local function unlock_markdown(msg, data, target)
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
if not is_mod(msg) then
  if not lang then
    return "⛔️ *You're Not Moderator*"
  else
    return "⛔️ شما مدیر گروه نمیباشید"
  end
end

local lock_markdown = data[tostring(target)]["settings"]["lock_markdown"]
if lock_markdown == "no" then
  if not lang then
    return "🔴 *Markdown Posting Is Not Locked*"
  elseif lang then
    return "🔴 ارسال پیام های دارای فونت در گروه ممنوع نمیباشد"
  end
else
  data[tostring(target)]["settings"]["lock_markdown"] = "no" save_data(_config.moderation.data, data)
  if not lang then
    return "✅ *Markdown Posting Has Been Unlocked*"
  else
    return "✅ ارسال پیام های دارای فونت در گروه آزاد شد"
  end
end
end

---------------Lock Webpage-------------------
local function lock_webpage(msg, data, target)
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
if not is_mod(msg) then
  if not lang then
    return "⛔️ *You're Not Moderator*"
  else
    return "⛔️ شما مدیر گروه نمیباشید"
  end
end

local lock_webpage = data[tostring(target)]["settings"]["lock_webpage"]
if lock_webpage == "yes" then
  if not lang then
    return "🔴 *Webpage Is Already Locked*"
  elseif lang then
    return "🔴 ارسال صفحات وب در گروه هم اکنون ممنوع است"
  end
else
  data[tostring(target)]["settings"]["lock_webpage"] = "yes"
  save_data(_config.moderation.data, data)
  if not lang then
    return "✅ *Webpage Has Been Locked*"
  else
    return "✅ ارسال صفحات وب در گروه ممنوع شد"
  end
end
end

local function unlock_webpage(msg, data, target)
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
if not is_mod(msg) then
  if not lang then
    return "⛔️ *You're Not Moderator*"
  else
    return "⛔️ شما مدیر گروه نمیباشید"
  end
end

local lock_webpage = data[tostring(target)]["settings"]["lock_webpage"]
if lock_webpage == "no" then
  if not lang then
    return "🔴 *Webpage Is Not Locked*"
  elseif lang then
    return "🔴 ارسال صفحات وب در گروه ممنوع نمیباشد"
  end
else
  data[tostring(target)]["settings"]["lock_webpage"] = "no"
  save_data(_config.moderation.data, data)
  if not lang then
    return "✅ *Webpage Has Been Unlocked*"
  else
    return "✅ *ارسال صفحات وب در گروه آزاد شد"
  end
end
end

---------------Lock Pin-------------------
local function lock_pin(msg, data, target)
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
if not is_mod(msg) then
  if not lang then
    return "⛔️ *You're Not Moderator*"
  else
    return "⛔️ شما مدیر گروه نمیباشید"
  end
end

local lock_pin = data[tostring(target)]["settings"]["lock_pin"]
if lock_pin == "yes" then
  if not lang then
    return "🔴 *Pinned Message Is Already Locked*"
  elseif lang then
    return "🔴 سنجاق کردن پیام در گروه هم اکنون ممنوع است"
  end
else
  data[tostring(target)]["settings"]["lock_pin"] = "yes"
  save_data(_config.moderation.data, data)
  if not lang then
    return "✅ *Pinned Message Has Been Locked*"
  else
    return "✅ سنجاق کردن پیام در گروه ممنوع شد"
  end
end
end

local function unlock_pin(msg, data, target)
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
if not is_mod(msg) then
  if not lang then
    return "⛔️ *You're Not Moderator*"
  else
    return "⛔️ شما مدیر گروه نمیباشید"
  end
end

local lock_pin = data[tostring(target)]["settings"]["lock_pin"]
if lock_pin == "no" then
  if not lang then
    return "🔴 *Pinned Message Is Not Locked*"
  elseif lang then
    return "🔴 سنجاق کردن پیام در گروه ممنوع نمیباشد"
  end
else
  data[tostring(target)]["settings"]["lock_pin"] = "no"
  save_data(_config.moderation.data, data)
  if not lang then
    return "✅ *Pinned Message Has Been Unlocked*"
  else
    return "✅ سنجاق کردن پیام در گروه آزاد شد"
  end
end
end

function group_settings(msg, target)
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
if not is_mod(msg) then
  if not lang then
    return "⛔️ *You're Not Moderator*"
  else
    return "⛔️ شما مدیر گروه نمیباشید"
  end
end
local data = load_data(_config.moderation.data)
local target = msg.to.id
if data[tostring(target)] then
  if data[tostring(target)]["settings"]["num_msg_max"] then
    NUM_MSG_MAX = tonumber(data[tostring(target)]['settings']['num_msg_max'])
    print('custom'..NUM_MSG_MAX)
  else
    NUM_MSG_MAX = 5
  end
end

if data[tostring(target)]["settings"] then
  if not data[tostring(target)]["settings"]["lock_link"] then
    data[tostring(target)]["settings"]["lock_link"] = "yes"
  end
end

if data[tostring(target)]["settings"] then
  if not data[tostring(target)]["settings"]["lock_tag"] then
    data[tostring(target)]["settings"]["lock_tag"] = "yes"
  end
end

if data[tostring(target)]["settings"] then
  if not data[tostring(target)]["settings"]["lock_mention"] then
    data[tostring(target)]["settings"]["lock_mention"] = "no"
  end
end

if data[tostring(target)]["settings"] then
  if not data[tostring(target)]["settings"]["lock_arabic"] then
    data[tostring(target)]["settings"]["lock_arabic"] = "no"
  end
end

if data[tostring(target)]["settings"] then
  if not data[tostring(target)]["settings"]["lock_edit"] then
    data[tostring(target)]["settings"]["lock_edit"] = "no"
  end
end

if data[tostring(target)]["settings"] then
  if not data[tostring(target)]["settings"]["lock_spam"] then
    data[tostring(target)]["settings"]["lock_spam"] = "yes"
  end
end

if data[tostring(target)]["settings"] then
  if not data[tostring(target)]["settings"]["lock_flood"] then
    data[tostring(target)]["settings"]["lock_flood"] = "yes"
  end
end

if data[tostring(target)]["settings"] then
  if not data[tostring(target)]["settings"]["lock_bots"] then
    data[tostring(target)]["settings"]["lock_bots"] = "yes"
  end
end

if data[tostring(target)]["settings"] then
  if not data[tostring(target)]["settings"]["lock_markdown"] then
    data[tostring(target)]["settings"]["lock_markdown"] = "no"
  end
end

if data[tostring(target)]["settings"] then
  if not data[tostring(target)]["settings"]["lock_webpage"] then
    data[tostring(target)]["settings"]["lock_webpage"] = "no"
  end
end

if data[tostring(target)]["settings"] then
  if not data[tostring(target)]["settings"]["welcome"] then
    data[tostring(target)]["settings"]["welcome"] = "no"
  end
end

if data[tostring(target)]["settings"] then
  if not data[tostring(target)]["settings"]["lock_pin"] then
    data[tostring(target)]["settings"]["lock_pin"] = "no"
  end
end
local expire_date = ''
local expi = redis:ttl('ExpireDate:'..msg.to.id)
if expi == -1 then
  if lang then
    expire_date = 'نامحدود!'
  else
    expire_date = 'Unlimited!'
  end
else
  local day = math.floor(expi / 86400) + 1
  if lang then
    expire_date = day..' روز'
  else
    expire_date = day..' Days'
  end
end
if not lang then

  local settings = data[tostring(target)]["settings"]
  text = "💠 *Group Settings:*\n\n*- Lock edit :* `"..settings.lock_edit.."`\n*- Lock links :* `"..settings.lock_link.."`\n*- Lock tags :* `"..settings.lock_tag.."`\n*- Lock flood :* `"..settings.flood.."`\n*- Lock spam* : `"..settings.lock_spam.."`\n*- Lock mention* : `"..settings.lock_mention.."`\n*- Lock arabic :* `"..settings.lock_arabic.."`\n*- Lock webpage :* `"..settings.lock_webpage.."`\n*- Lock markdown :* `"..settings.lock_markdown.."`\n*- Group welcome :* `"..settings.welcome.."`\n*- Lock pin message :* `"..settings.lock_pin.."`\n*- Bots protection :* `"..settings.lock_bots.."`\n*- Flood sensitivity :* `"..NUM_MSG_MAX.."`\n➖➖➖\n*- Expire Date :* `"..expire_date.."`\n*- Group Language :* `EN`\n\n*- Channel:* @OctaCH\n"
else
  local settings = data[tostring(target)]["settings"]
  text = "💠 تنظیمات گروه:\n- قفل ویرایش پیام : "..settings.lock_edit.."\n- قفل لینک : "..settings.lock_link.."\n- قفل تگ : "..settings.lock_tag.."\n- قفل پیام مکرر : "..settings.flood.."\n- قفل هرزنامه : "..settings.lock_spam.."\n- قفل فراخوانی : "..settings.lock_mention.."\n- قفل عربی : "..settings.lock_arabic.."\n- قفل صفحات وب : "..settings.lock_webpage.."\n- قفل فونت : "..settings.lock_markdown.."\n- پیام خوشآمد گویی : "..settings.welcome.."\n- قفل سنجاق کردن : "..settings.lock_pin.."\n- محافظت در برابر ربات ها : "..settings.lock_bots.."\n- حداکثر پیام مکرر : `"..NUM_MSG_MAX.."`\n\n➖➖➖\n- تاریخ انقضا : "..expire_date.."\n- زبان سوپرگروه : `FA`\n - کانال ما: @OctaCH\n"
end
return text
end
--------Mutes---------
--------Mute all--------------------------
local function mute_all(msg, data, target)
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
if not is_mod(msg) then
  if not lang then
    return "⛔️ *You're Not Moderator*"
  else
    return "⛔️ شما مدیر گروه نمیباشید"
  end
end

local mute_all = data[tostring(target)]["mutes"]["mute_all"]
if mute_all == "yes" then
  if not lang then
    return "🔴 *Mute All Is Already Enabled*"
  elseif lang then
    return "🔴 بیصدا کردن همه فعال است"
  end
else
  data[tostring(target)]["mutes"]["mute_all"] = "yes"
  save_data(_config.moderation.data, data)
  if not lang then
    return "✅ *Mute All Has Been Enabled*"
  else
    return "✅ بیصدا کردن همه فعال شد"
  end
end
end

local function unmute_all(msg, data, target)
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
if not is_mod(msg) then
  if not lang then
    return "⛔️ *You're Not Moderator*"
  else
    return "⛔️ شما مدیر گروه نمیباشید"
  end
end

local mute_all = data[tostring(target)]["mutes"]["mute_all"]
if mute_all == "no" then
  if not lang then
    return "🔴 *Mute All Is Already Disabled*"
  elseif lang then
    return "🔴 بیصدا کردن همه غیر فعال است"
  end
else
  data[tostring(target)]["mutes"]["mute_all"] = "no"
  save_data(_config.moderation.data, data)
  if not lang then
    return "✅ *Mute All Has Been Disabled*"
  else
    return "✅ بیصدا کردن همه غیر فعال شد"
  end
end
end

---------------Mute Gif-------------------
local function mute_gif(msg, data, target)
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
if not is_mod(msg) then
  if not lang then
    return "⛔️ *You're Not Moderator*"
  else
    return "⛔️ شما مدیر گروه نمیباشید"
  end
end

local mute_gif = data[tostring(target)]["mutes"]["mute_gif"]
if mute_gif == "yes" then
  if not lang then
    return "🔴 *Mute Gif Is Already Enabled*"
  elseif lang then
    return "🔴 بیصدا کردن تصاویر متحرک فعال است"
  end
else
  data[tostring(target)]["mutes"]["mute_gif"] = "yes"
  save_data(_config.moderation.data, data)
  if not lang then
    return "✅ *Mute Gif Has Been Enabled*"
  else
    return "✅ بیصدا کردن تصاویر متحرک فعال شد"
  end
end
end

local function unmute_gif(msg, data, target)
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
if not is_mod(msg) then
  if not lang then
    return "⛔️ *You're Not Moderator*"
  else
    return "⛔️ شما مدیر گروه نمیباشید"
  end
end

local mute_gif = data[tostring(target)]["mutes"]["mute_gif"]
if mute_gif == "no" then
  if not lang then
    return "🔴 *Mute Gif Is Already Disabled*"
  elseif lang then
    return "🔴 بیصدا کردن تصاویر متحرک غیر فعال بود"
  end
else
  data[tostring(target)]["mutes"]["mute_gif"] = "no"
  save_data(_config.moderation.data, data)
  if not lang then
    return "✅ *Mute Gif Has Been Disabled*"
  else
    return "✅ بیصدا کردن تصاویر متحرک غیر فعال شد"
  end
end
end
---------------Mute Game-------------------
local function mute_game(msg, data, target)
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
if not is_mod(msg) then
  if not lang then
    return "⛔️ *You're Not Moderator*"
  else
    return "⛔️ شما مدیر گروه نمیباشید"
  end
end

local mute_game = data[tostring(target)]["mutes"]["mute_game"]
if mute_game == "yes" then
  if not lang then
    return "🔴 *Mute Game Is Already Enabled*"
  elseif lang then
    return "🔴 بیصدا کردن بازی های تحت وب فعال است"
  end
else
  data[tostring(target)]["mutes"]["mute_game"] = "yes"
  save_data(_config.moderation.data, data)
  if not lang then
    return "✅ *Mute Game Has Been Enabled*"
  else
    return "✅ بیصدا کردن بازی های تحت وب فعال شد"
  end
end
end

local function unmute_game(msg, data, target)
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
if not is_mod(msg) then
  if not lang then
    return "⛔️ *You're Not Moderator*"
  else
    return "⛔️ شما مدیر گروه نمیباشید"
  end
end

local mute_game = data[tostring(target)]["mutes"]["mute_game"]
if mute_game == "no" then
  if not lang then
    return "🔴 *Mute Game Is Already Disabled*"
  elseif lang then
    return "🔴 بیصدا کردن بازی های تحت وب غیر فعال است"
  end
else
  data[tostring(target)]["mutes"]["mute_game"] = "no"
  save_data(_config.moderation.data, data)
  if not lang then
    return "✅ *Mute Game Has Been Disabled*"
  else
    return "✅ بیصدا کردن بازی های تحت وب غیر فعال شد"
  end
end
end
---------------Mute Inline-------------------
local function mute_inline(msg, data, target)
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
if not is_mod(msg) then
  if not lang then
    return "⛔️ *You're Not Moderator*"
  else
    return "⛔️ شما مدیر گروه نمیباشید"
  end
end

local mute_inline = data[tostring(target)]["mutes"]["mute_inline"]
if mute_inline == "yes" then
  if not lang then
    return "🔴 *Mute Inline Is Already Enabled*"
  elseif lang then
    return "🔴 بیصدا کردن کیبورد شیشه ای فعال است"
  end
else
  data[tostring(target)]["mutes"]["mute_inline"] = "yes"
  save_data(_config.moderation.data, data)
  if not lang then
    return "✅ *Mute Inline Has Been Enabled*"
  else
    return "✅ بیصدا کردن کیبورد شیشه ای فعال شد"
  end
end
end

local function unmute_inline(msg, data, target)
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
if not is_mod(msg) then
  if not lang then
    return "⛔️ *You're Not Moderator*"
  else
    return "⛔️ شما مدیر گروه نمیباشید"
  end
end

local mute_inline = data[tostring(target)]["mutes"]["mute_inline"]
if mute_inline == "no" then
  if not lang then
    return "🔴 *Mute Inline Is Already Disabled*"
  elseif lang then
    return "🔴 بیصدا کردن کیبورد شیشه ای غیر فعال است"
  end
else
  data[tostring(target)]["mutes"]["mute_inline"] = "no"
  save_data(_config.moderation.data, data)
  if not lang then
    return "✅ *Mute Inline Has Been Disabled*"
  else
    return "✅ بیصدا کردن کیبورد شیشه ای غیر فعال شد"
  end
end
end
---------------Mute Text-------------------
local function mute_text(msg, data, target)
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
if not is_mod(msg) then
  if not lang then
    return "⛔️ *You're Not Moderator*"
  else
    return "⛔️ شما مدیر گروه نمیباشید"
  end
end

local mute_text = data[tostring(target)]["mutes"]["mute_text"]
if mute_text == "yes" then
  if not lang then
    return "🔴 *Mute Text Is Already Enabled*"
  elseif lang then
    return "🔴 بیصدا کردن متن فعال است"
  end
else
  data[tostring(target)]["mutes"]["mute_text"] = "yes"
  save_data(_config.moderation.data, data)
  if not lang then
    return "✅ *Mute Text Has Been Enabled*"
  else
    return "✅ بیصدا کردن متن فعال شد"
  end
end
end

local function unmute_text(msg, data, target)
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
if not is_mod(msg) then
  if not lang then
    return "⛔️ *You're Not Moderator*"
  else
    return "⛔️ شما مدیر گروه نمیباشید"
  end
end

local mute_text = data[tostring(target)]["mutes"]["mute_text"]
if mute_text == "no" then
  if not lang then
    return "🔴 *Mute Text Is Already Disabled*"
  elseif lang then
    return "🔴 بیصدا کردن متن غیر فعال است"
  end
else
  data[tostring(target)]["mutes"]["mute_text"] = "no"
  save_data(_config.moderation.data, data)
  if not lang then
    return "✅ *Mute Text Has Been Disabled*"
  else
    return "✅ بیصدا کردن متن غیر فعال شد"
  end
end
end
---------------Mute photo-------------------
local function mute_photo(msg, data, target)
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
if not is_mod(msg) then
  if not lang then
    return "⛔️ *You're Not Moderator*"
  else
    return "⛔️ شما مدیر گروه نمیباشید"
  end
end

local mute_photo = data[tostring(target)]["mutes"]["mute_photo"]
if mute_photo == "yes" then
  if not lang then
    return "🔴 *Mute Photo Is Already Enabled*"
  elseif lang then
    return "🔴 بیصدا کردن عکس فعال است"
  end
else
  data[tostring(target)]["mutes"]["mute_photo"] = "yes"
  save_data(_config.moderation.data, data)
  if not lang then
    return "✅ *Mute Photo Has Been Enabled*"
  else
    return "✅ *بیصدا کردن عکس فعال شد"
  end
end
end

local function unmute_photo(msg, data, target)
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
if not is_mod(msg) then
  if not lang then
    return "⛔️ *You're Not Moderator*"
  else
    return "⛔️ شما مدیر گروه نمیباشید"
  end
end

local mute_photo = data[tostring(target)]["mutes"]["mute_photo"]
if mute_photo == "no" then
  if not lang then
    return "🔴 *Mute Photo Is Already Disabled*"
  elseif lang then
    return "🔴 بیصدا کردن عکس غیر فعال است"
  end
else
  data[tostring(target)]["mutes"]["mute_photo"] = "no"
  save_data(_config.moderation.data, data)
  if not lang then
    return "✅ *Mute Photo Has Been Disabled*"
  else
    return "✅ بیصدا کردن عکس غیر فعال شد"
  end
end
end
---------------Mute Video-------------------
local function mute_video(msg, data, target)
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
if not is_mod(msg) then
  if not lang then
    return "⛔️ *You're Not Moderator*"
  else
    return "⛔️ شما مدیر گروه نمیباشید"
  end
end

local mute_video = data[tostring(target)]["mutes"]["mute_video"]
if mute_video == "yes" then
  if not lang then
    return "🔴 *Mute Video Is Already Enabled*"
  elseif lang then
    return "🔴 بیصدا کردن فیلم فعال است"
  end
else
  data[tostring(target)]["mutes"]["mute_video"] = "yes"
  save_data(_config.moderation.data, data)
  if not lang then
    return "✅ *Mute Video Has Been Enabled*"
  else
    return "✅ بیصدا کردن فیلم فعال شد"
  end
end
end

local function unmute_video(msg, data, target)
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
if not is_mod(msg) then
  if not lang then
    return "⛔️ *You're Not Moderator*"
  else
    return "⛔️ شما مدیر گروه نمیباشید"
  end
end

local mute_video = data[tostring(target)]["mutes"]["mute_video"]
if mute_video == "no" then
  if not lang then
    return "🔴 *Mute Video Is Already Disabled*"
  elseif lang then
    return "🔴 بیصدا کردن فیلم غیر فعال است"
  end
else
  data[tostring(target)]["mutes"]["mute_video"] = "no"
  save_data(_config.moderation.data, data)
  if not lang then
    return "✅ *Mute Video Has Been Disabled*"
  else
    return "✅ بیصدا کردن فیلم غیر فعال شد"
  end
end
end
---------------Mute Audio-------------------
local function mute_audio(msg, data, target)
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
if not is_mod(msg) then
  if not lang then
    return "⛔️ *You're Not Moderator*"
  else
    return "⛔️ شما مدیر گروه نمیباشید"
  end
end

local mute_audio = data[tostring(target)]["mutes"]["mute_audio"]
if mute_audio == "yes" then
  if not lang then
    return "🔴 *Mute Audio Is Already Enabled*"
  elseif lang then
    return "🔴 بیصدا کردن آهنگ فعال است"
  end
else
  data[tostring(target)]["mutes"]["mute_audio"] = "yes"
  save_data(_config.moderation.data, data)
  if not lang then
    return "✅ *Mute Audio Has Been Enabled*"
  else
    return "✅ بیصدا کردن آهنگ فعال شد"
  end
end
end

local function unmute_audio(msg, data, target)
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
if not is_mod(msg) then
  if not lang then
    return "⛔️ *You're Not Moderator*"
  else
    return "⛔️ شما مدیر گروه نمیباشید"
  end
end

local mute_audio = data[tostring(target)]["mutes"]["mute_audio"]
if mute_audio == "no" then
  if not lang then
    return "🔴 *Mute Audio Is Already Disabled*"
  elseif lang then
    return "🔴 بیصدا کردن آهنک غیر فعال است"
  end
else
  data[tostring(target)]["mutes"]["mute_audio"] = "no"
  save_data(_config.moderation.data, data)
  if not lang then
    return "✅ *Mute Audio Has Been Disabled*"
  else
    return "✅ بیصدا کردن آهنگ غیر فعال شد"
  end
end
end
---------------Mute Voice-------------------
local function mute_voice(msg, data, target)
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
if not is_mod(msg) then
  if not lang then
    return "⛔️ *You're Not Moderator*"
  else
    return "⛔️ شما مدیر گروه نمیباشید"
  end
end

local mute_voice = data[tostring(target)]["mutes"]["mute_voice"]
if mute_voice == "yes" then
  if not lang then
    return "🔴 *Mute Voice Is Already Enabled*"
  elseif lang then
    return "🔴 بیصدا کردن صدا فعال است"
  end
else
  data[tostring(target)]["mutes"]["mute_voice"] = "yes"
  save_data(_config.moderation.data, data)
  if not lang then
    return "✅ *Mute Voice Has Been Enabled*"
  else
    return "✅ بیصدا کردن صدا فعال شد"
  end
end
end

local function unmute_voice(msg, data, target)
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
if not is_mod(msg) then
  if not lang then
    return "⛔️ *You're Not Moderator*"
  else
    return "⛔️ شما مدیر گروه نمیباشید"
  end
end

local mute_voice = data[tostring(target)]["mutes"]["mute_voice"]
if mute_voice == "no" then
  if not lang then
    return "✅ *Mute Voice Is Already Disabled*"
  elseif lang then
    return "✅ بیصدا کردن صدا غیر فعال است"
  end
else
  data[tostring(target)]["mutes"]["mute_voice"] = "no"
  save_data(_config.moderation.data, data)
  if not lang then
    return "✅ *Mute Voice Has Been Disabled*"
  else
    return "✅ بیصدا کردن صدا غیر فعال شد"
  end
end
end
---------------Mute Sticker-------------------
local function mute_sticker(msg, data, target)
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
if not is_mod(msg) then
  if not lang then
    return "⛔️ *You're Not Moderator*"
  else
    return "⛔️ شما مدیر گروه نمیباشید"
  end
end

local mute_sticker = data[tostring(target)]["mutes"]["mute_sticker"]
if mute_sticker == "yes" then
  if not lang then
    return "🔴 *Mute Sticker Is Already Enabled*"
  elseif lang then
    return "🔴 بیصدا کردن برچسب فعال است"
  end
else
  data[tostring(target)]["mutes"]["mute_sticker"] = "yes"
  save_data(_config.moderation.data, data)
  if not lang then
    return "✅ *Mute Sticker Has Been Enabled*"
  else
    return "✅ بیصدا کردن برچسب فعال شد"
  end
end
end

local function unmute_sticker(msg, data, target)
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
if not is_mod(msg) then
  if not lang then
    return "⛔️ *You're Not Moderator*"
  else
    return "⛔️ شما مدیر گروه نمیباشید"
  end
end

local mute_sticker = data[tostring(target)]["mutes"]["mute_sticker"]
if mute_sticker == "no" then
  if not lang then
    return "🔴 *Mute Sticker Is Already Disabled*"
  elseif lang then
    return "🔴 بیصدا کردن برچسب غیر فعال است"
  end
else
  data[tostring(target)]["mutes"]["mute_sticker"] = "no"
  save_data(_config.moderation.data, data)
  if not lang then
    return "✅ *Mute Sticker Has Been Disabled*"
  else
    return "✅ بیصدا کردن برچسب غیر فعال شد"
  end
end
end
---------------Mute Contact-------------------
local function mute_contact(msg, data, target)
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
if not is_mod(msg) then
  if not lang then
    return "⛔️ *You're Not Moderator*"
  else
    return "⛔️ شما مدیر گروه نمیباشید"
  end
end

local mute_contact = data[tostring(target)]["mutes"]["mute_contact"]
if mute_contact == "yes" then
  if not lang then
    return "🔴 *Mute Contact Is Already Enabled*"
  elseif lang then
    return "🔴 بیصدا کردن مخاطب فعال است"
  end
else
  data[tostring(target)]["mutes"]["mute_contact"] = "yes"
  save_data(_config.moderation.data, data)
  if not lang then
    return "✅ *Mute Contact Has Been Enabled*"
  else
    return "✅ بیصدا کردن مخاطب فعال شد"
  end
end
end

local function unmute_contact(msg, data, target)
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
if not is_mod(msg) then
  if not lang then
    return "⛔️ *You're Not Moderator*"
  else
    return "⛔️ شما مدیر گروه نمیباشید"
  end
end

local mute_contact = data[tostring(target)]["mutes"]["mute_contact"]
if mute_contact == "no" then
  if not lang then
    return "🔴 *Mute Contact Is Already Disabled*"
  elseif lang then
    return "🔴 بیصدا کردن مخاطب غیر فعال است"
  end
else
  data[tostring(target)]["mutes"]["mute_contact"] = "no"
  save_data(_config.moderation.data, data)
  if not lang then
    return "✅ *Mute Contact Has Been Disabled*"
  else
    return "✅ بیصدا کردن مخاطب غیر فعال شد"
  end
end
end
---------------Mute Forward-------------------
local function mute_forward(msg, data, target)
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
if not is_mod(msg) then
  if not lang then
    return "⛔️ *You're Not Moderator*"
  else
    return "⛔️ شما مدیر گروه نمیباشید"
  end
end

local mute_forward = data[tostring(target)]["mutes"]["mute_forward"]
if mute_forward == "yes" then
  if not lang then
    return "🔴 *Mute Forward Is Already Enabled*"
  elseif lang then
    return "🔴 بیصدا کردن نقل قول فعال است"
  end
else
  data[tostring(target)]["mutes"]["mute_forward"] = "yes"
  save_data(_config.moderation.data, data)
  if not lang then
    return "✅ *Mute Forward Has Been Enabled*"
  else
    return "✅ بیصدا کردن نقل قول فعال شد"
  end
end
end

local function unmute_forward(msg, data, target)
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
if not is_mod(msg) then
  if not lang then
    return "⛔️ *You're Not Moderator*"
  else
    return "⛔️ شما مدیر گروه نمیباشید"
  end
end

local mute_forward = data[tostring(target)]["mutes"]["mute_forward"]
if mute_forward == "no" then
  if not lang then
    return "🔴 *Mute Forward Is Already Disabled*"
  elseif lang then
    return "🔴 بیصدا کردن نقل قول غیر فعال است"
  end
else
  data[tostring(target)]["mutes"]["mute_forward"] = "no"
  save_data(_config.moderation.data, data)
  if not lang then
    return "✅ *Mute Forward Has Been Disabled*"
  else
    return "✅ بیصدا کردن نقل قول غیر فعال شد"
  end
end
end
---------------Mute Location-------------------
local function mute_location(msg, data, target)
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
if not is_mod(msg) then
  if not lang then
    return "⛔️ *You're Not Moderator*"
  else
    return "⛔️ شما مدیر گروه نمیباشید"
  end
end

local mute_location = data[tostring(target)]["mutes"]["mute_location"]
if mute_location == "yes" then
  if not lang then
    return "🔴 *Mute Location Is Already Enabled*"
  elseif lang then
    return "🔴 بیصدا کردن موقعیت فعال است"
  end
else
  data[tostring(target)]["mutes"]["mute_location"] = "yes"
  save_data(_config.moderation.data, data)
  if not lang then
    return "✅ *Mute Location Has Been Enabled*"
  else
    return "بیصدا کردن موقعیت فعال شد"
  end
end
end

local function unmute_location(msg, data, target)
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
if not is_mod(msg) then
  if not lang then
    return "⛔️ *You're Not Moderator*"
  else
    return "⛔️ شما مدیر گروه نمیباشید"
  end
end

local mute_location = data[tostring(target)]["mutes"]["mute_location"]
if mute_location == "no" then
  if not lang then
    return "🔴 *Mute Location Is Already Disabled*"
  elseif lang then
    return "🔴 بیصدا کردن موقعیت غیر فعال است"
  end
else
  data[tostring(target)]["mutes"]["mute_location"] = "no"
  save_data(_config.moderation.data, data)
  if not lang then
    return "✅ *Mute Location Has Been Disabled*"
  else
    return "✅ بیصدا کردن موقعیت غیر فعال شد"
  end
end
end
---------------Mute Document-------------------
local function mute_document(msg, data, target)
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
if not is_mod(msg) then
  if not lang then
    return "⛔️ *You're Not Moderator*"
  else
    return "⛔️ شما مدیر گروه نمیباشید"
  end
end

local mute_document = data[tostring(target)]["mutes"]["mute_document"]
if mute_document == "yes" then
  if not lang then
    return "🔴 *Mute Document Is Already Enabled*"
  elseif lang then
    return "🔴 بیصدا کردن اسناد فعال لست"
  end
else
  data[tostring(target)]["mutes"]["mute_document"] = "yes"
  save_data(_config.moderation.data, data)
  if not lang then
    return "✅ *Mute Document Has Been Enabled*"
  else
    return "✅ بیصدا کردن اسناد فعال شد"
  end
end
end

local function unmute_document(msg, data, target)
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
if not is_mod(msg) then
  if not lang then
    return "⛔️ *You're Not Moderator*"
  else
    return "⛔️ شما مدیر گروه نمیباشید"
  end
end

local mute_document = data[tostring(target)]["mutes"]["mute_document"]
if mute_document == "no" then
  if not lang then
    return "🔴 *Mute Document Is Already Disabled*"
  elseif lang then
    return "🔴 بیصدا کردن اسناد غیر فعال است"
  end
else
  data[tostring(target)]["mutes"]["mute_document"] = "no"
  save_data(_config.moderation.data, data)
  if not lang then
    return "✅ *Mute Document Has Been Disabled*"
  else
    return "✅ بیصدا کردن اسناد غیر فعال شد"
  end
end
end
---------------Mute TgService-------------------
local function mute_tgservice(msg, data, target)
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
if not is_mod(msg) then
  if not lang then
    return "⛔️ *You're Not Moderator*"
  else
    return "⛔️ شما مدیر گروه نمیباشید"
  end
end

local mute_tgservice = data[tostring(target)]["mutes"]["mute_tgservice"]
if mute_tgservice == "yes" then
  if not lang then
    return "🔴 *Mute TgService Is Already Enabled*"
  elseif lang then
    return "🔴 بیصدا کردن خدمات تلگرام فعال است"
  end
else
  data[tostring(target)]["mutes"]["mute_tgservice"] = "yes"
  save_data(_config.moderation.data, data)
  if not lang then
    return "✅ *Mute TgService Has Been Enabled*"
  else
    return "✅ بیصدا کردن خدمات تلگرام فعال شد"
  end
end
end

local function unmute_tgservice(msg, data, target)
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
if not is_mod(msg) then
  if not lang then
    return "⛔️ *You're Not Moderator*"
  else
    return "شما مدیر گروه نیستید"
  end
end

local mute_tgservice = data[tostring(target)]["mutes"]["mute_tgservice"]
if mute_tgservice == "no" then
  if not lang then
    return "*Mute TgService Is Already Disabled*"
  elseif lang then
    return "🔴 بیصدا کردن خدمات تلگرام غیر فعال است"
  end
else
  data[tostring(target)]["mutes"]["mute_tgservice"] = "no"
  save_data(_config.moderation.data, data)
  if not lang then
    return "✅ *Mute TgService Has Been Disabled*"
  else
    return "✅ بیصدا کردن خدمات تلگرام غیر فعال شد"
  end
end
end

---------------Mute Keyboard-------------------
local function mute_keyboard(msg, data, target)
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
if not is_mod(msg) then
  if not lang then
    return "⛔️ *You're Not Moderator*"
  else
    return "⛔️ شما مدیر گروه نمیباشید"
  end
end

local mute_keyboard = data[tostring(target)]["mutes"]["mute_keyboard"]
if mute_keyboard == "yes" then
  if not lang then
    return "🔴 *Mute Keyboard Is Already Enabled*"
  elseif lang then
    return "🔴 بیصدا کردن صفحه کلید فعال است"
  end
else
  data[tostring(target)]["mutes"]["mute_keyboard"] = "yes"
  save_data(_config.moderation.data, data)
  if not lang then
    return "✅ *Mute Keyboard Has Been Enabled*"
  else
    return "✅ بیصدا کردن صفحه کلید فعال شد"
  end
end
end

local function unmute_keyboard(msg, data, target)
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
if not is_mod(msg) then
  if not lang then
    return "*You're Not Moderator*"
  else
    return "⛔️ شما مدیر گروه نیستید"
  end
end

local mute_keyboard = data[tostring(target)]["mutes"]["mute_keyboard"]
if mute_keyboard == "no" then
  if not lang then
    return "*Mute Keyboard Is Already Disabled*"
  elseif lang then
    return "🔴 بیصدا کردن صفحه کلید غیرفعال است"
  end
else
  data[tostring(target)]["mutes"]["mute_keyboard"] = "no"
  save_data(_config.moderation.data, data)
  if not lang then
    return "✅ *Mute TgService Has Been Disabled*"
  else
    return "✅ بیصدا کردن صفحه کلید غیرفعال شد"
  end
end
end
----------MuteList---------
local function mutes(msg, target)
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
if not is_mod(msg) then
  if not lang then
    return "⛔️ *You're Not Moderator*"
  else
    return "⛔️ شما مدیر گروه نیستید"
  end
end
local data = load_data(_config.moderation.data)
local target = msg.to.id
if data[tostring(target)]["mutes"] then
  if not data[tostring(target)]["mutes"]["mute_all"] then
    data[tostring(target)]["mutes"]["mute_all"] = "no"
  end
end
if data[tostring(target)]["mutes"] then
  if not data[tostring(target)]["mutes"]["mute_gif"] then
    data[tostring(target)]["mutes"]["mute_gif"] = "no"
  end
end
if data[tostring(target)]["mutes"] then
  if not data[tostring(target)]["mutes"]["mute_text"] then
    data[tostring(target)]["mutes"]["mute_text"] = "no"
  end
end
if data[tostring(target)]["mutes"] then
  if not data[tostring(target)]["mutes"]["mute_photo"] then
    data[tostring(target)]["mutes"]["mute_photo"] = "no"
  end
end
if data[tostring(target)]["mutes"] then
  if not data[tostring(target)]["mutes"]["mute_video"] then
    data[tostring(target)]["mutes"]["mute_video"] = "no"
  end
end
if data[tostring(target)]["mutes"] then
  if not data[tostring(target)]["mutes"]["mute_audio"] then
    data[tostring(target)]["mutes"]["mute_audio"] = "no"
  end
end
if data[tostring(target)]["mutes"] then
  if not data[tostring(target)]["mutes"]["mute_voice"] then
    data[tostring(target)]["mutes"]["mute_voice"] = "no"
  end
end
if data[tostring(target)]["mutes"] then
  if not data[tostring(target)]["mutes"]["mute_sticker"] then
    data[tostring(target)]["mutes"]["mute_sticker"] = "no"
  end
end
if data[tostring(target)]["mutes"] then
  if not data[tostring(target)]["mutes"]["mute_contact"] then
    data[tostring(target)]["mutes"]["mute_contact"] = "no"
  end
end
if data[tostring(target)]["mutes"] then
  if not data[tostring(target)]["mutes"]["mute_forward"] then
    data[tostring(target)]["mutes"]["mute_forward"] = "no"
  end
end
if data[tostring(target)]["mutes"] then
  if not data[tostring(target)]["mutes"]["mute_location"] then
    data[tostring(target)]["mutes"]["mute_location"] = "no"
  end
end
if data[tostring(target)]["mutes"] then
  if not data[tostring(target)]["mutes"]["mute_document"] then
    data[tostring(target)]["mutes"]["mute_document"] = "no"
  end
end
if data[tostring(target)]["mutes"] then
  if not data[tostring(target)]["mutes"]["mute_tgservice"] then
    data[tostring(target)]["mutes"]["mute_tgservice"] = "no"
  end
end
if data[tostring(target)]["mutes"] then
  if not data[tostring(target)]["mutes"]["mute_inline"] then
    data[tostring(target)]["mutes"]["mute_inline"] = "no"
  end
end
if data[tostring(target)]["mutes"] then
  if not data[tostring(target)]["mutes"]["mute_game"] then
    data[tostring(target)]["mutes"]["mute_game"] = "no"
  end
end
if data[tostring(target)]["mutes"] then
  if not data[tostring(target)]["mutes"]["mute_keyboard"] then
    data[tostring(target)]["mutes"]["mute_keyboard"] = "no"
  end
end
if not lang then
  local mutes = data[tostring(target)]["mutes"]
  text = "💠 *Group Mute List :*\n\n*- Mute all :* `"..mutes.mute_all.."`\n*- Mute gif :* `"..mutes.mute_gif.."`\n*- Mute text :* `"..mutes.mute_text.."`\n*- Mute inline :* `"..mutes.mute_inline.."`\n*- Mute game :* `"..mutes.mute_game.."`\n*- Mute photo :* `"..mutes.mute_photo.."`\n*- Mute video :* `"..mutes.mute_video.."`\n*- Mute audio :* `"..mutes.mute_audio.."`\n*- Mute voice :* `"..mutes.mute_voice.."`\n*- Mute sticker :* `"..mutes.mute_sticker.."`\n*- Mute contact :* `"..mutes.mute_contact.."`\n*- Mute forward :* `"..mutes.mute_forward.."`\n*- Mute location :* `"..mutes.mute_location.."`\n*- Mute document :* `"..mutes.mute_document.."`\n*- Mute TgService :* `"..mutes.mute_tgservice.."`\n*- Mute Keyboard :* `"..mutes.mute_keyboard.."`\n\n➖➖➖\n*Bot channel:* @OctaCH\n*Group Language* : `EN`"
else
  local mutes = data[tostring(target)]["mutes"]
  text = "💠 لیست بیصدا ها : \n\n- بیصدا همه :  *"..mutes.mute_all.."*\n- بیصدا تصاویر متحرک : *"..mutes.mute_gif.."*\n- بیصدا متن : *"..mutes.mute_text.."*\n- بیصدا کیبورد شیشه ای : *"..mutes.mute_inline.."*\n- بیصدا بازی های تحت وب : *"..mutes.mute_game.."*\n- بیصدا عکس : *"..mutes.mute_photo.."*\n- بیصدا فیلم : *"..mutes.mute_video.."*\n- بیصدا آهنگ : *"..mutes.mute_audio.."*\n- بیصدا صدا : *"..mutes.mute_voice.."*\n- بیصدا برچسب : *"..mutes.mute_sticker.."*\n- بیصدا مخاطب : *"..mutes.mute_contact.."*\n- بیصدا نقل قول : *"..mutes.mute_forward.."*\n- بیصدا موقعیت : *"..mutes.mute_location.."*\n- بیصدا اسناد : *"..mutes.mute_document.."*\n- بیصدا خدمات تلگرام : *"..mutes.mute_tgservice.."*\n- بیصدا صفحه کلید : *"..mutes.mute_keyboard.."*\n\n➖➖➖\nزبان سوپرگروه : `FA`\nکانال ما: @OctaCH"
end
return text
end

local function run(msg, matches)
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
local data = load_data(_config.moderation.data)
local chat = msg.to.id
local user = msg.from.id
if msg.to.type ~= 'pv' then
  if matches[1] == "id" then
    if not matches[2] and not msg.reply_id then
      local function getpro(arg, data)
        if data.photos_[0] then
          if not lang then
            tdcli.sendPhoto(msg.chat_id_, msg.id_, 0, 1, nil, data.photos_[0].sizes_[1].photo_.persistent_id_,'Chat ID : '..msg.to.id..'\nUser ID : '..msg.from.id,dl_cb,nil)
          elseif lang then
            tdcli.sendPhoto(msg.chat_id_, msg.id_, 0, 1, nil, data.photos_[0].sizes_[1].photo_.persistent_id_,'شناسه گروه : '..msg.to.id..'\nشناسه شما : '..msg.from.id,dl_cb,nil)
          end
        else
          if not lang then
            tdcli.sendMessage(msg.to.id, msg.id_, 1, "*You Have Not Profile Photo...!*\n\n> *Chat ID :* `"..msg.to.id.."`\n*User ID :* `"..msg.from.id.."`", 1, 'md')
          elseif lang then
            tdcli.sendMessage(msg.to.id, msg.id_, 1, "شما هیچ عکسی ندارید...!\n\n> شناسه گروه : `"..msg.to.id.."`\nشناسه شما : `"..msg.from.id.."`", 1, 'md')
          end
        end
      end
      tdcli_function ({
        ID = "GetUserProfilePhotos",
        user_id_ = msg.from.id,
        offset_ = 0,
        limit_ = 1
      }, getpro, nil)
    end
    if msg.reply_id and not matches[2] then
      tdcli_function ({
        ID = "GetMessage",
        chat_id_ = msg.to.id,
        message_id_ = msg.reply_id
      }, action_by_reply, {chat_id=msg.to.id,cmd="id"})
    end
    if matches[2] then
      tdcli_function ({
        ID = "SearchPublicChat",
        username_ = matches[2]
      }, action_by_username, {chat_id=msg.to.id,username=matches[2],cmd="id"})
    end
  end
  if matches[1] == "pin" and is_mod(msg) and msg.reply_id then
    local lock_pin = data[tostring(msg.to.id)]["settings"]["lock_pin"]
    if lock_pin == 'yes' then
      if is_owner(msg) then
        data[tostring(chat)]['pin'] = msg.reply_id
        save_data(_config.moderation.data, data)
        tdcli.pinChannelMessage(msg.to.id, msg.reply_id, 1)
        if not lang then
          return "*Message Has Been Pinned*"
        elseif lang then
          return "پیام سجاق شد"
        end
      elseif not is_owner(msg) then
        return
      end
    elseif lock_pin == 'no' then
      data[tostring(chat)]['pin'] = msg.reply_id
      save_data(_config.moderation.data, data)
      tdcli.pinChannelMessage(msg.to.id, msg.reply_id, 1)
      if not lang then
        return "✅ *Message Has Been Pinned*"
      elseif lang then
        return "پیام سجاق شد"
      end
    end
  end
  if matches[1] == 'unpin' and is_mod(msg) then
    local lock_pin = data[tostring(msg.to.id)]["settings"]["lock_pin"]
    if lock_pin == 'yes' then
      if is_owner(msg) then
        tdcli.unpinChannelMessage(msg.to.id)
        if not lang then
          return "✅ *Pinned message has been unpinned*"
        elseif lang then
          return "پیام سنجاق شده پاک شد"
        end
      elseif not is_owner(msg) then
        return
      end
    elseif lock_pin == 'no' then
      tdcli.unpinChannelMessage(msg.to.id)
      if not lang then
        return "✅ *Pinned message has been unpinned*"
      elseif lang then
        return "پیام سنجاق شده پاک شد"
      end
    end
  end
  if matches[1] == "add" then
    return modadd(msg)
  end
  if matches[1] == "rem" then
    return modrem(msg)
  end
  if matches[1] == "setowner" and is_admin(msg) then
    if not matches[2] and msg.reply_id then
      tdcli_function ({
        ID = "GetMessage",
        chat_id_ = msg.to.id,
        message_id_ = msg.reply_id
      }, action_by_reply, {chat_id=msg.to.id,cmd="setowner"})
    end
    if matches[2] and string.match(matches[2], '^%d+$') then
      tdcli_function ({
        ID = "GetUser",
        user_id_ = matches[2],
      }, action_by_id, {chat_id=msg.to.id,user_id=matches[2],cmd="setowner"})
    end
    if matches[2] and not string.match(matches[2], '^%d+$') then
      tdcli_function ({
        ID = "SearchPublicChat",
        username_ = matches[2]
      }, action_by_username, {chat_id=msg.to.id,username=matches[2],cmd="setowner"})
    end
  end
  if matches[1] == "remowner" and is_admin(msg) then
    if not matches[2] and msg.reply_id then
      tdcli_function ({
        ID = "GetMessage",
        chat_id_ = msg.to.id,
        message_id_ = msg.reply_id
      }, action_by_reply, {chat_id=msg.to.id,cmd="remowner"})
    end
    if matches[2] and string.match(matches[2], '^%d+$') then
      tdcli_function ({
        ID = "GetUser",
        user_id_ = matches[2],
      }, action_by_id, {chat_id=msg.to.id,user_id=matches[2],cmd="remowner"})
    end
    if matches[2] and not string.match(matches[2], '^%d+$') then
      tdcli_function ({
        ID = "SearchPublicChat",
        username_ = matches[2]
      }, action_by_username, {chat_id=msg.to.id,username=matches[2],cmd="remowner"})
    end
  end
  if matches[1] == "promote" and is_owner(msg) then
    if not matches[2] and msg.reply_id then
      tdcli_function ({
        ID = "GetMessage",
        chat_id_ = msg.to.id,
        message_id_ = msg.reply_id
      }, action_by_reply, {chat_id=msg.to.id,cmd="promote"})
    end
    if matches[2] and string.match(matches[2], '^%d+$') then
      tdcli_function ({
        ID = "GetUser",
        user_id_ = matches[2],
      }, action_by_id, {chat_id=msg.to.id,user_id=matches[2],cmd="promote"})
    end
    if matches[2] and not string.match(matches[2], '^%d+$') then
      tdcli_function ({
        ID = "SearchPublicChat",
        username_ = matches[2]
      }, action_by_username, {chat_id=msg.to.id,username=matches[2],cmd="promote"})
    end
  end
  if matches[1] == "demote" and is_owner(msg) then
    if not matches[2] and msg.reply_id then
      tdcli_function ({
        ID = "GetMessage",
        chat_id_ = msg.to.id,
        message_id_ = msg.reply_id
      }, action_by_reply, {chat_id=msg.to.id,cmd="demote"})
    end
    if matches[2] and string.match(matches[2], '^%d+$') then
      tdcli_function ({
        ID = "GetUser",
        user_id_ = matches[2],
      }, action_by_id, {chat_id=msg.to.id,user_id=matches[2],cmd="demote"})
    end
    if matches[2] and not string.match(matches[2], '^%d+$') then
      tdcli_function ({
        ID = "SearchPublicChat",
        username_ = matches[2]
      }, action_by_username, {chat_id=msg.to.id,username=matches[2],cmd="demote"})
    end
  end

  if matches[1] == "lock" and is_mod(msg) then
    local target = msg.to.id
    if matches[2] == "link" then
      return lock_link(msg, data, target)
    end
    if matches[2] == "tag" then
      return lock_tag(msg, data, target)
    end
    if matches[2] == "mention" then
      return lock_mention(msg, data, target)
    end
    if matches[2] == "arabic" then
      return lock_arabic(msg, data, target)
    end
    if matches[2] == "edit" then
      return lock_edit(msg, data, target)
    end
    if matches[2] == "spam" then
      return lock_spam(msg, data, target)
    end
    if matches[2] == "flood" then
      return lock_flood(msg, data, target)
    end
    if matches[2] == "bots" then
      return lock_bots(msg, data, target)
    end
    if matches[2] == "markdown" then
      return lock_markdown(msg, data, target)
    end
    if matches[2] == "webpage" then
      return lock_webpage(msg, data, target)
    end
    if matches[2] == "pin" and is_owner(msg) then
      return lock_pin(msg, data, target)
    end
  end

  if matches[1] == "unlock" and is_mod(msg) then
    local target = msg.to.id
    if matches[2] == "link" then
      return unlock_link(msg, data, target)
    end
    if matches[2] == "tag" then
      return unlock_tag(msg, data, target)
    end
    if matches[2] == "mention" then
      return unlock_mention(msg, data, target)
    end
    if matches[2] == "arabic" then
      return unlock_arabic(msg, data, target)
    end
    if matches[2] == "edit" then
      return unlock_edit(msg, data, target)
    end
    if matches[2] == "spam" then
      return unlock_spam(msg, data, target)
    end
    if matches[2] == "flood" then
      return unlock_flood(msg, data, target)
    end
    if matches[2] == "bots" then
      return unlock_bots(msg, data, target)
    end
    if matches[2] == "markdown" then
      return unlock_markdown(msg, data, target)
    end
    if matches[2] == "webpage" then
      return unlock_webpage(msg, data, target)
    end
    if matches[2] == "pin" and is_owner(msg) then
      return unlock_pin(msg, data, target)
    end
  end
  if matches[1] == "mute" and is_mod(msg) then
    local target = msg.to.id
    if matches[2] == "all" then
      return mute_all(msg, data, target)
    end
    if matches[2] == "gif" then
      return mute_gif(msg, data, target)
    end
    if matches[2] == "text" then
      return mute_text(msg ,data, target)
    end
    if matches[2] == "photo" then
      return mute_photo(msg ,data, target)
    end
    if matches[2] == "video" then
      return mute_video(msg ,data, target)
    end
    if matches[2] == "audio" then
      return mute_audio(msg ,data, target)
    end
    if matches[2] == "voice" then
      return mute_voice(msg ,data, target)
    end
    if matches[2] == "sticker" then
      return mute_sticker(msg ,data, target)
    end
    if matches[2] == "contact" then
      return mute_contact(msg ,data, target)
    end
    if matches[2] == "forward" then
      return mute_forward(msg ,data, target)
    end
    if matches[2] == "location" then
      return mute_location(msg ,data, target)
    end
    if matches[2] == "document" then
      return mute_document(msg ,data, target)
    end
    if matches[2] == "tgservice" then
      return mute_tgservice(msg ,data, target)
    end
    if matches[2] == "inline" then
      return mute_inline(msg ,data, target)
    end
    if matches[2] == "game" then
      return mute_game(msg ,data, target)
    end
    if matches[2] == "keyboard" then
      return mute_keyboard(msg ,data, target)
    end
  end

  if matches[1] == "unmute" and is_mod(msg) then
    local target = msg.to.id
    if matches[2] == "all" then
      return unmute_all(msg, data, target)
    end
    if matches[2] == "gif" then
      return unmute_gif(msg, data, target)
    end
    if matches[2] == "text" then
      return unmute_text(msg, data, target)
    end
    if matches[2] == "photo" then
      return unmute_photo(msg ,data, target)
    end
    if matches[2] == "video" then
      return unmute_video(msg ,data, target)
    end
    if matches[2] == "audio" then
      return unmute_audio(msg ,data, target)
    end
    if matches[2] == "voice" then
      return unmute_voice(msg ,data, target)
    end
    if matches[2] == "sticker" then
      return unmute_sticker(msg ,data, target)
    end
    if matches[2] == "contact" then
      return unmute_contact(msg ,data, target)
    end
    if matches[2] == "forward" then
      return unmute_forward(msg ,data, target)
    end
    if matches[2] == "location" then
      return unmute_location(msg ,data, target)
    end
    if matches[2] == "document" then
      return unmute_document(msg ,data, target)
    end
    if matches[2] == "tgservice" then
      return unmute_tgservice(msg ,data, target)
    end
    if matches[2] == "inline" then
      return unmute_inline(msg ,data, target)
    end
    if matches[2] == "game" then
      return unmute_game(msg ,data, target)
    end
    if matches[2] == "keyboard" then
      return unmute_keyboard(msg ,data, target)
    end
  end
  if matches[1] == "gpinfo" and is_mod(msg) and msg.to.type == "channel" then
    local function group_info(arg, data)
      local hash = "gp_lang:"..arg.chat_id
      local lang = redis:get(hash)
      if not lang then
        ginfo = "💠 *Group Info :*\n\n*Admin Count :* `"..data.administrator_count_.."`\n*Member Count :* `"..data.member_count_.."`\n*Kicked Count :* `"..data.kicked_count_.."`\n*Group ID :* `"..data.channel_.id_.."`"
        print(serpent.block(data))
      elseif lang then
        ginfo = "💠 *اطلاعات گروه :*\nتعداد مدیران : `"..data.administrator_count_.."`\nتعداد اعضا : `"..data.member_count_.."`\nتعداد اعضای حذف شده : `"..data.kicked_count_.."`\nشناسه گروه : `"..data.channel_.id_.."`"
        print(serpent.block(data))
      end
      tdcli.sendMessage(arg.chat_id, arg.msg_id, 1, ginfo, 1, 'md')
    end
    tdcli.getChannelFull(msg.to.id, group_info, {chat_id=msg.to.id,msg_id=msg.id})
  end
  if matches[1] == 'newlink' and is_mod(msg) then
    local function callback_link (arg, data)
      local hash = "gp_lang:"..msg.to.id
      local lang = redis:get(hash)
      local administration = load_data(_config.moderation.data)
      if not data.invite_link_ then
        administration[tostring(msg.to.id)]['settings']['linkgp'] = nil
        save_data(_config.moderation.data, administration)
        if not lang then
          return tdcli.sendMessage(msg.to.id, msg.id, 1, "🔴 *Bot is not group creator*\n*- set a link for group with using* /setlink", 1, 'md')
        elseif lang then
          return tdcli.sendMessage(msg.to.id, msg.id, 1, "🔴 ربات سازنده گروه نیست\nبا دستور setlink/ لینک جدیدی برای گروه ثبت کنید", 1, 'md')
        end
      else
        administration[tostring(msg.to.id)]['settings']['linkgp'] = data.invite_link_
        save_data(_config.moderation.data, administration)
        if not lang then
          return tdcli.sendMessage(msg.to.id, msg.id, 1, "✅ *Newlink Created*", 1, 'md')
        elseif lang then
          return tdcli.sendMessage(msg.to.id, msg.id, 1, "✅ لینک جدید ساخته شد", 1, 'md')
        end
      end
    end
    tdcli.exportChatInviteLink(msg.to.id, callback_link, nil)
  end
  if matches[1] == 'setlink' and is_owner(msg) then
    data[tostring(chat)]['settings']['linkgp'] = 'waiting'
    save_data(_config.moderation.data, data)
    if not lang then
      return '🔵 *Please send the new group link now*'
    else
      return '🔵 لطفا لینک گروه خود را ارسال کنید'
    end
  end

  if msg.text then
    local is_link = msg.text:match("^([https?://w]*.?telegram.me/joinchat/%S+)$") or msg.text:match("^([https?://w]*.?t.me/joinchat/%S+)$")
    if is_link and data[tostring(chat)]['settings']['linkgp'] == 'waiting' and is_owner(msg) then
      data[tostring(chat)]['settings']['linkgp'] = msg.text
      save_data(_config.moderation.data, data)
      if not lang then
        return "✅ *Newlink has been set*"
      else
        return "✅ لینک جدید ذخیره شد"
      end
    end
  end
  if matches[1] == 'link' and is_mod(msg) then
    local linkgp = data[tostring(chat)]['settings']['linkgp']
    if not linkgp then
      if not lang then
        return "🔴 *First create a link for group with using* /newlink\n*- If bot not group creator set a link with using* /setlink"
      else
        return "🔴 ابتدا با دستور newlink/ لینک جدیدی برای گروه بسازید\nو اگر ربات سازنده گروه نیس با دستور setlink/ لینک جدیدی برای گروه ثبت کنید"
      end
    end
    if not lang then
      text = "<b>💠 Group Link :</b>\n"..linkgp
    else
      text = "💠 لینک گروه :\n"..linkgp
    end
    return tdcli.sendMessage(chat, msg.id, 1, text, 1, 'html')
  end
  if matches[1] == 'linkpv' and is_mod(msg) then
    local linkgp = data[tostring(chat)]['settings']['linkgp']
    if not linkgp then
      if not lang then
        return "🔴 -First create a link for group with using* /newlink\n*- If bot not group creator set a link with using* /setlink"
      else
        return "🔴 ابتدا با دستور newlink/ لینک جدیدی برای گروه بسازید\nو اگر ربات سازنده گروه نیس با دستور setlink/ لینک جدیدی برای گروه ثبت کنید"
      end
    end
    if not lang then
      tdcli.sendMessage(user, "", 1, "<b>Group Link "..msg.to.title.." :</b>\n"..linkgp, 1, 'html')
    else
      tdcli.sendMessage(user, "", 1, "<b>لینک گروه "..msg.to.title.." :</b>\n"..linkgp, 1, 'html')
    end
    if not lang then
      return "✅ *Group Link Was Send In Your Private Message*"
    else
      return "✅  لینک گروه به چت خصوصی شما ارسال شد"
    end
  end
  if matches[1] == "setrules" and matches[2] and is_mod(msg) then
    data[tostring(chat)]['rules'] = matches[2]
    save_data(_config.moderation.data, data)
    if not lang then
      return "✅ *Group rules has been set*"
    else
      return "✅ قوانین گروه ثبت شد"
    end
  end
  if matches[1] == "rules" then
    if not data[tostring(chat)]['rules'] then
      if not lang then
        rules = "ℹ️ The Default Rules :\n1⃣ No Flood.\n2⃣ No Spam.\n3⃣ No Advertising.\n4⃣ Try to stay on topic.\n5⃣ Forbidden any racist, sexual, homophobic or gore content.\n➡️ Repeated failure to comply with these rules will cause ban.\n@OctaCH"
      elseif lang then
        rules = "ℹ️ قوانین پپیشفرض:\n1⃣ ارسال پیام مکرر ممنوع.\n2⃣ اسپم ممنوع.\n3⃣ تبلیغ ممنوع.\n4⃣ سعی کنید از موضوع خارج نشید.\n5⃣ هرنوع نژاد پرستی, شاخ بازی و پورنوگرافی ممنوع .\n➡️ از قوانین پیروی کنید, در صورت عدم رعایت قوانین اول اخطار و در صورت تکرار مسدود.\n@OctaCH"
      end
    else
      rules = "💠 *Group Rules :*\n"..data[tostring(chat)]['rules']
    end
    return rules
  end
  if matches[1] == "res" and matches[2] and is_mod(msg) then
    tdcli_function ({
      ID = "SearchPublicChat",
      username_ = matches[2]
    }, action_by_username, {chat_id=msg.to.id,username=matches[2],cmd="res"})
  end
  if matches[1] == "whois" and matches[2] and is_mod(msg) then
    tdcli_function ({
      ID = "GetUser",
      user_id_ = matches[2],
    }, action_by_id, {chat_id=msg.to.id,user_id=matches[2],cmd="whois"})
  end
  if matches[1] == 'setflood' and is_mod(msg) then
    if tonumber(matches[2]) < 1 or tonumber(matches[2]) > 50 then
      return "🔴 *Wrong number, range is* `[1-50]`"
    end
    local flood_max = matches[2]
    data[tostring(chat)]['settings']['num_msg_max'] = flood_max
    save_data(_config.moderation.data, data)
    return "✅ *Group flood sensitivity has been set to :* `[ "..matches[2].." ]`"
  end
  if matches[1]:lower() == 'clean' and is_owner(msg) then
    if matches[2] == 'mods' then
      if next(data[tostring(chat)]['mods']) == nil then
        if not lang then
          return "🔴 *No moderators in this group*"
        else
          return "🔴 هیچ مدیری برای گروه انتخاب نشده است"
        end
      end
      for k,v in pairs(data[tostring(chat)]['mods']) do
        data[tostring(chat)]['mods'][tostring(k)] = nil
        save_data(_config.moderation.data, data)
      end
      if not lang then
        return "✅ *All moderators has been demoted*"
      else
        return "✅ تمام مدیران گروه تنزیل مقام شدند"
      end
    end
    if matches[2] == 'filterlist' then
      if next(data[tostring(chat)]['filterlist']) == nil then
        if not lang then
          return "🔴 *Filtered words list is empty*"
        else
          return "🔴 لیست کلمات فیلتر شده خالی است"
        end
      end
      for k,v in pairs(data[tostring(chat)]['filterlist']) do
        data[tostring(chat)]['filterlist'][tostring(k)] = nil
        save_data(_config.moderation.data, data)
      end
      if not lang then
        return "✅ *Filtered words list has been cleaned*"
      else
        return "✅ لیست کلمات فیلتر شده پاک شد"
      end
    end
    if matches[2] == 'rules' then
      if not data[tostring(chat)]['rules'] then
        if not lang then
          return "🔴 *No rules available*"
        else
          return "🔴 قوانین برای گروه ثبت نشده است"
        end
      end
      data[tostring(chat)]['rules'] = nil
      save_data(_config.moderation.data, data)
      if not lang then
        return "✅ *Group rules has been cleaned*"
      else
        return "✅ قوانین گروه پاک شد"
      end
    end
    if matches[2] == 'welcome' then
      if not data[tostring(chat)]['setwelcome'] then
        if not lang then
          return "🔴 *Welcome Message not set*"
        else
          return "🔴 پیام خوشآمد گویی ثبت نشده است"
        end
      end
      data[tostring(chat)]['setwelcome'] = nil
      save_data(_config.moderation.data, data)
      if not lang then
        return "✅ *Welcome message has been cleaned*"
      else
        return "✅ پیام خوشآمد گویی پاک شد"
      end
    end
    if matches[2] == 'about' then
      if msg.to.type == "chat" then
        if not data[tostring(chat)]['about'] then
          if not lang then
            return "🔴 *No description available*"
          else
            return "🔴 پیامی مبنی بر درباره گروه ثبت نشده است"
          end
        end
        data[tostring(chat)]['about'] = nil
        save_data(_config.moderation.data, data)
      elseif msg.to.type == "channel" then
        tdcli.changeChannelAbout(chat, "", dl_cb, nil)
      end
      if not lang then
        return "✅ *Group description has been cleaned*"
      else
        return "✅ پیام مبنی بر درباره گروه پاک شد"
      end
    end
  end
  if matches[1]:lower() == 'clean' and is_admin(msg) then
    if matches[2] == 'owners' then
      if next(data[tostring(chat)]['owners']) == nil then
        if not lang then
          return "🔴 *No owners in this group*"
        else
          return "🔴 مالکی برای گروه انتخاب نشده است"
        end
      end
      for k,v in pairs(data[tostring(chat)]['owners']) do
        data[tostring(chat)]['owners'][tostring(k)] = nil
        save_data(_config.moderation.data, data)
      end
      if not lang then
        return "✅ *All owners has been demoted*"
      else
        return "✅ تمامی مالکان گروه تنزیل مقام شدند"
      end
    end
  end
  if matches[1] == "setname" and matches[2] and is_mod(msg) then
    local gp_name = matches[2]
    tdcli.changeChatTitle(chat, gp_name, dl_cb, nil)
  end
  if matches[1] == "setabout" and matches[2] and is_mod(msg) then
    if msg.to.type == "channel" then
      tdcli.changeChannelAbout(chat, matches[2], dl_cb, nil)
    elseif msg.to.type == "chat" then
      data[tostring(chat)]['about'] = matches[2]
      save_data(_config.moderation.data, data)
    end
    if not lang then
      return "✅ *Group description has been set*"
    else
      return "✅ پیام مبنی بر درباره گروه ثبت شد"
    end
  end
  if matches[1] == "about" and msg.to.type == "chat" then
    if not data[tostring(chat)]['about'] then
      if not lang then
        about = "🔴 *No description available*"
      elseif lang then
        about = "🔴 پیامی مبنی بر درباره گروه ثبت نشده است"
      end
    else
      about = "💠 *Group Description :*\n"..data[tostring(chat)]['about']
    end
    return about
  end
  if matches[1] == 'filter' and is_mod(msg) then
    return filter_word(msg, matches[2])
  end
  if matches[1] == 'unfilter' and is_mod(msg) then
    return unfilter_word(msg, matches[2])
  end
  if matches[1] == 'filterlist' and is_mod(msg) then
    return filter_list(msg)
  end
  if matches[1] == "settings" then
    return group_settings(msg, target)
  end
  if matches[1] == "mutelist" then
    return mutes(msg, target)
  end
  if matches[1] == "modlist" then
    return modlist(msg)
  end
  if matches[1] == "ownerlist" and is_owner(msg) then
    return ownerlist(msg)
  end
  if matches[1] == "config" and is_admin(msg) then
    return config(msg)
  end
  if matches[1] == "setlang" and is_owner(msg) then
    if matches[2] == "en" then
      local hash = "gp_lang:"..msg.to.id
      local lang = redis:get(hash)
      redis:del(hash)
      return "✅ *Group Language Set To:* `EN`"
    elseif matches[2] == "fa" then
      redis:set(hash, true)
      return "✅ زبان گروه تنظیم شد به : `فارسی`"
    end
  end

  if matches[1] == "help" and is_mod(msg) then
    if not lang then
      text = [[
      *Beyond Bot Commands:*

      *!setowner* `[username|id|reply]`
      _Set Group Owner(Multi Owner)_

      *!remowner* `[username|id|reply]`
      _Remove User From Owner List_

      *!promote* `[username|id|reply]`
      _Promote User To Group Admin_

      *!demote* `[username|id|reply]`
      _Demote User From Group Admins List_

      *!setflood* `[1-50]`
      _Set Flooding Number_

      *!silent* `[username|id|reply]`
      _Silent User From Group_

      *!unsilent* `[username|id|reply]`
      _Unsilent User From Group_

      *!kick* `[username|id|reply]`
      _Kick User From Group_

      *!ban* `[username|id|reply]`
      _Ban User From Group_

      *!unban* `[username|id|reply]`
      _UnBan User From Group_

      *!res* `[username]`
      _Show User ID_

      *!id* `[reply]`
      _Show User ID_

      *!whois* `[id]`
      _Show User's Username And Name_

      *!lock* `[link | tag | edit | arabic | webpage | bots | spam | flood | markdown | mention | pin]`
      _If This Actions Lock, Bot Check Actions And Delete Them_

      *!unlock* `[link | tag | edit | arabic | webpage | bots | spam | flood | markdown | mention | pin]`
      _If This Actions Unlock, Bot Not Delete Them_

      *!mute* `[gif | photo | document | sticker | keyboard | video | text | forward | location | audio | voice | contact | all]`
      _If This Actions Lock, Bot Check Actions And Delete Them_

      *!unmute* `[gif | photo | document | sticker | keyboard | video | text | forward | location | audio | voice | contact | all]`
      _If This Actions Unlock, Bot Not Delete Them_

      *!set*`[rules | name | photo | link | about | welcome]`
      _Bot Set Them_

      *!clean* `[bans | mods | bots | rules | about | silentlist | filtelist | welcome]`
      _Bot Clean Them_

      *!filter* `[word]`
      _Word filter_

      *!unfilter* `[word]`
      _Word unfilter_

      *!pin* `[reply]`
      _Pin Your Message_

      *!unpin*
      _Unpin Pinned Message_

      *!welcome enable/disable*
      _Enable Or Disable Group Welcome_

      *!settings*
      _Show Group Settings_

      *!mutelist*
      _Show Mutes List_

      *!silentlist*
      _Show Silented Users List_

      *!filterlist*
      _Show Filtered Words List_

      *!banlist*
      _Show Banned Users List_

      *!ownerlist*
      _Show Group Owners List_

      *!modlist*
      _Show Group Moderators List_

      *!rules*
      _Show Group Rules_

      *!about*
      _Show Group Description_

      *!id*
      _Show Your And Chat ID_

      *!gpinfo*
      _Show Group Information_

      *!newlink*
      _Create A New Link_

      *!link*
      _Show Group Link_

      *!linkpv*
      _Send Group Link In Your Private Message_

      *!setwelcome [text]*
      _set Welcome Message_

      *!helptools*
      _Show Tools Help_

      *!helpfun*
      _Show Fun Help_

      _You Can Use_ *[!/#]* _To Run The Commands_
      _This Help List Only For_ *Moderators/Owners!*
      _Its Means, Only Group_ *Moderators/Owners* _Can Use It!_

      *Good luck ;)*]]

    elseif lang then

      text = [[
      *دستورات ربات اُکتا:*

      *!setowner* `[username|id|reply]`
      _انتخاب مالک گروه(قابل انتخاب چند مالک)_

      *!remowner* `[username|id|reply]`
      _حذف کردن فرد از فهرست مالکان گروه_

      *!promote* `[username|id|reply]`
      _ارتقا مقام کاربر به مدیر گروه_

      *!demote* `[username|id|reply]`
      _تنزیل مقام مدیر به کاربر_

      *!setflood* `[1-50]`
      _تنظیم حداکثر تعداد پیام مکرر_

      *!silent* `[username|id|reply]`
      _بیصدا کردن کاربر در گروه_

      *!unsilent* `[username|id|reply]`
      _در آوردن کاربر از حالت بیصدا در گروه_

      *!kick* `[username|id|reply]`
      _حذف کاربر از گروه_

      *!ban* `[username|id|reply]`
      _مسدود کردن کاربر از گروه_

      *!unban* `[username|id|reply]`
      _در آوردن از حالت مسدودیت کاربر از گروه_

      *!res* `[username]`
      _نمایش شناسه کاربر_

      *!id* `[reply]`
      _نمایش شناسه کاربر_

      *!whois* `[id]`
      _نمایش نام کاربر, نام کاربری و اطلاعات حساب_

      *!lock* `[link | tag | edit | arabic | webpage | bots | spam | flood | markdown | mention | pin]`
      _در صورت قفل بودن فعالیت ها, ربات آنهارا حذف خواهد کرد_

      *!unlock* `[link | tag | edit | arabic | webpage | bots | spam | flood | markdown | mention | pin]`
      _در صورت قفل نبودن فعالیت ها, ربات آنهارا حذف نخواهد کرد_

      *!mute* `[gif | photo | document | sticker | keyboard | video | text | forward | location | audio | voice | contact | all]`
      _در صورت بیصدد بودن فعالیت ها, ربات آنهارا حذف خواهد کرد_

      *!unmute* `[gif | photo | document | sticker | keyboard | video | text | forward | location | audio | voice | contact | all]`
      _در صورت بیصدا نبودن فعالیت ها, ربات آنهارا حذف نخواهد کرد_

      *!set*`[rules | name | photo | link | about | welcome]`
      _ربات آنهارا ثبت خواهد کرد_

      *!clean* `[bans | mods | bots | rules | about | silentlist | filterlist | welcome]`
      _ربات آنهارا پاک خواهد کرد_

      *!filter* `[word]`
      _فیلتر‌کلمه مورد نظر_

      *!unfilter* `[word]`
      _ازاد کردن کلمه مورد نظر_

      *!pin* `[reply]`
      _ربات پیام شمارا در گروه سنجاق خواهد کرد_

      *!unpin*
      _ربات پیام سنجاق شده در گروه را حذف خواهد کرد_

      *!welcome enable/disable*
      _فعال یا غیرفعال کردن خوشآمد گویی_

      *!settings*
      _نمایش تنظیمات گروه_

      *!mutelist*
      _نمایش فهرست بیصدا های گروه_

      *!silentlist*
      _نمایش فهرست افراد بیصدا_

      *!filterlist*
      _نمایش لیست کلمات فیلتر شده_

      *!banlist*
      _نمایش افراد مسدود شده از گروه_

      *!ownerlist*
      _نمایش فهرست مالکان گروه_

      *!modlist*
      _نمایش فهرست مدیران گروه_

      *!rules*
      _نمایش قوانین گروه_

      *!about*
      _نمایش درباره گروه_

      *!id*
      _نمایش شناسه شما و گروه_

      *!gpinfo*
      _نمایش اطلاعات گروه_

      !*newlink*
      _ساخت لینک جدید_

      *!link*
      _نمایش لینک گروه_

      *!linkpv*
      _ارسال لینک گروه به چت خصوصی شما_

      *!setwelcome [text]*
      _ثبت پیام خوش آمد گویی_

      *!helptools*
      _نمایش راهنمای Tools_

      *!helpfun*
      _نمایش راهنمای سرگرمی_

      _شما میتوانید از [!/#] در اول دستورات برای اجرای آنها بهره بگیرید

      این راهنما فقط برای مدیران/مالکان گروه میباشد!

      این به این معناست که فقط مدیران/مالکان گروه میتوانند از دستورات بالا استفاده کنند!_

      *موفق باشید ;)*]]
    end
    return text
  end
  --------------------- Welcome -----------------------
  if matches[1] == "welcome" and is_mod(msg) then
    if matches[2] == "enable" then
      welcome = data[tostring(chat)]['settings']['welcome']
      if welcome == "yes" then
        if not lang then
          return "🔴 *Group welcome is already enabled*"
        elseif lang then
          return "🔴 خوشآمد گویی از قبل فعال بود"
        end
      else
        data[tostring(chat)]['settings']['welcome'] = "yes"
        save_data(_config.moderation.data, data)
        if not lang then
          return "✅ *Group welcome has been enabled*"
        elseif lang then
          return "✅ خوشآمد گویی فعال شد"
        end
      end
    end

    if matches[2] == "disable" then
      welcome = data[tostring(chat)]['settings']['welcome']
      if welcome == "no" then
        if not lang then
          return "🔴 *Group Welcome is already disabled*"
        elseif lang then
          return "🔴 خوشآمد گویی از قبل فعال نبود"
        end
      else
        data[tostring(chat)]['settings']['welcome'] = "no"
        save_data(_config.moderation.data, data)
        if not lang then
          return "✅ *Group welcome has been disabled*"
        elseif lang then
          return "✅ خوشآمد گویی غیرفعال شد"
        end
      end
    end
  end
  if matches[1] == "setwelcome" and matches[2] and is_mod(msg) then
    data[tostring(chat)]['setwelcome'] = matches[2]
    save_data(_config.moderation.data, data)
    if not lang then
      return "✅ *Welcome Message Has Been Set To :*\n"..matches[2].."\n\n*You can use :*\n`{gpname}` ➣ *Group Name*\n`{rules}` ➣ *Show Group Rules*\n`{name}` ➣ *New Member First Name*\n`{username}` ➣ *New Member Username*"
    else
      return "✅ پیام خوشآمد گویی تنظیم شد به :\n"..matches[2].."\n\nشما میتوانید از\n`{gpname}` ➣ نام گروه\n`{rules}` ➣ نمایش قوانین گروه\n`{name}` ➣ نام کاربر جدید\n`{username}` ➣ نام کاربری کاربر جدید\nاستفاده کنید"
    end
  end
end
end
-----------------------------------------
local function pre_process(msg)
local chat = msg.to.id
local user = msg.from.id
local data = load_data(_config.moderation.data)
local function welcome_cb(arg, data)
  local hash = "gp_lang:"..arg.chat_id
  local lang = redis:get(hash)
  administration = load_data(_config.moderation.data)
  if administration[arg.chat_id]['setwelcome'] then
    welcome = administration[arg.chat_id]['setwelcome']
  else
    if not lang then
      welcome = "*Welcome*"
    elseif lang then
      welcome = "خوش آمدید"
    end
  end
  if administration[tostring(arg.chat_id)]['rules'] then
    rules = administration[arg.chat_id]['rules']
  else
    if not lang then
      rules = "ℹ️ The Default Rules :\n1⃣ No Flood.\n2⃣ No Spam.\n3⃣ No Advertising.\n4⃣ Try to stay on topic.\n5⃣ Forbidden any racist, sexual, homophobic or gore content.\n➡️ Repeated failure to comply with these rules will cause ban.\n@OCTAB_CH"
    elseif lang then
      rules = "ℹ️ قوانین پپیشفرض:\n1⃣ ارسال پیام مکرر ممنوع.\n2⃣ اسپم ممنوع.\n3⃣ تبلیغ ممنوع.\n4⃣ سعی کنید از موضوع خارج نشید.\n5⃣ هرنوع نژاد پرستی, شاخ بازی و پورنوگرافی ممنوع .\n➡️ از قوانین پیروی کنید, در صورت عدم رعایت قوانین اول اخطار و در صورت تکرار مسدود.\n@OCTAB_CH"
    end
  end
  if data.username_ then
    user_name = "@"..check_markdown(data.username_)
  else
    user_name = ""
  end
  local welcome = welcome:gsub("{rules}", rules)
  local welcome = welcome:gsub("{name}", check_markdown(data.first_name_))
  local welcome = welcome:gsub("{username}", user_name)
  local welcome = welcome:gsub("{gpname}", arg.gp_name)
  tdcli.sendMessage(arg.chat_id, arg.msg_id, 0, welcome, 0, "md")
end
if data[tostring(chat)] and data[tostring(chat)]['settings'] then
  if msg.adduser then
    welcome = data[tostring(msg.to.id)]['settings']['welcome']
    if welcome == "yes" then
      tdcli_function ({
        ID = "GetUser",
        user_id_ = msg.adduser
      }, welcome_cb, {chat_id=chat,msg_id=msg.id,gp_name=msg.to.title})
    else
      return false
    end
  end
  if msg.joinuser then
    welcome = data[tostring(msg.to.id)]['settings']['welcome']
    if welcome == "yes" then
      tdcli_function ({
        ID = "GetUser",
        user_id_ = msg.joinuser
      }, welcome_cb, {chat_id=chat,msg_id=msg.id,gp_name=msg.to.title})
    else
      return false
    end
  end
end
-- return msg
end
return {
patterns ={
  "^[!/#](id)$",
  "^[!/#](id) (.*)$",
  "^[!/#](pin)$",
  "^[!/#](unpin)$",
  "^[!/#](gpinfo)$",
  "^[!/#](test)$",
  "^[!/#](add)$",
  "^[!/#](rem)$",
  "^[!/#](setowner)$",
  "^[!/#](setowner) (.*)$",
  "^[!/#](remowner)$",
  "^[!/#](remowner) (.*)$",
  "^[!/#](promote)$",
  "^[!/#](promote) (.*)$",
  "^[!/#](demote)$",
  "^[!/#](demote) (.*)$",
  "^[!/#](modlist)$",
  "^[!/#](ownerlist)$",
  "^[!/#](lock) (.*)$",
  "^[!/#](unlock) (.*)$",
  "^[!/#](settings)$",
  "^[!/#](mutelist)$",
  "^[!/#](mute) (.*)$",
  "^[!/#](unmute) (.*)$",
  "^[!/#](link)$",
  "^[!/#](linkpv)$",
  "^[!/#](setlink)$",
  "^[!/#](newlink)$",
  "^[!/#](rules)$",
  "^[!/#](setrules) (.*)$",
  "^[!/#](about)$",
  "^[!/#](config)$",
  "^[!/#](setabout) (.*)$",
  "^[!/#](setname) (.*)$",
  "^[!/#](clean) (.*)$",
  "^[!/#](setflood) (%d+)$",
  "^[!/#](res) (.*)$",
  "^[!/#](whois) (%d+)$",
  "^[!/#](help)$",
  "^[!/#](setlang) (.*)$",
  "^[#!/](filter) (.*)$",
  "^[#!/](unfilter) (.*)$",
  "^[#!/](filterlist)$",
  "^([https?://w]*.?t.me/joinchat/%S+)$",
  "^([https?://w]*.?telegram.me/joinchat/%S+)$",
  "^[!/#](setwelcome) (.*)",
  "^[!/#](welcome) (.*)$"

},
run=run,
pre_process = pre_process
}
--end groupmanager.lua #beyond team#

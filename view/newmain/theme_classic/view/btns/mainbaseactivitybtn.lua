local var0 = class("MainBaseActivityBtn")

function var0.Ctor(arg0, arg1, arg2, arg3)
	arg0.tpl = arg1

	pg.DelegateInfo.New(arg0)

	arg0.event = arg2

	if arg3 then
		arg0._tf = arg0.tpl
	end
end

function var0.GetLinkConfig(arg0)
	local var0 = arg0:GetEventName()
	local var1 = pg.activity_link_button
	local var2 = var1.get_id_list_by_name[var0] or {}
	local var3 = _.select(var2, function(arg0)
		local var0 = var1[arg0].time

		if type(var0) == "table" and var0[1] and var0[1] == "default" then
			return arg0:InActTime(var0[2])
		else
			return pg.TimeMgr.GetInstance():inTime(var0)
		end
	end)

	if #var3 > 0 then
		table.sort(var3, function(arg0, arg1)
			return var1[arg0].order < var1[arg1].order
		end)

		return var1[var3[1]]
	end
end

function var0.InActTime(arg0, arg1)
	local var0 = arg1 or arg0:GetActivityID()

	if var0 then
		local var1 = getProxy(ActivityProxy):getActivityById(var0)

		return var1 and not var1:isEnd()
	end

	return false
end

function var0.InShowTime(arg0)
	local var0 = arg0:GetLinkConfig()

	if var0 ~= nil then
		arg0.config = var0

		return true
	else
		return false
	end
end

function var0.NewGameObject(arg0)
	return arg0._tf or Object.Instantiate(arg0.tpl, arg0.tpl.parent).transform
end

function var0.Init(arg0, arg1)
	arg0._tf = arg0:NewGameObject()
	arg0._tf.gameObject.name = arg0.__cname
	arg0.image = arg0._tf:Find("Image"):GetComponent(typeof(Image))
	arg0.subImage = arg0._tf:Find("sub_Image"):GetComponent(typeof(Image))
	arg0.tipTr = arg0._tf:Find("Tip"):GetComponent(typeof(Image))
	arg0.tipTxt = arg0._tf:Find("Tip/Text"):GetComponent(typeof(Text))

	setActive(arg0._tf, true)

	arg0.tipTxt.text = ""

	arg0:InitTipImage()
	arg0:UpdatePosition(arg1)
	arg0:InitSubImage()
	arg0:InitImage(function()
		arg0:OnInit()
		arg0:Register()
	end)
end

function var0.Register(arg0)
	onButton(arg0, arg0._tf, function()
		if arg0.config.type <= 0 then
			arg0:CustomOnClick()
		else
			arg0:OnClick()
		end
	end, SFX_MAIN)
end

function var0.OnClick(arg0)
	var0.Skip(arg0, arg0.config)
end

function var0.InitImage(arg0, arg1)
	local var0 = arg0.config.pic

	if not var0 or var0 == arg0.imgName then
		arg1()

		return
	end

	LoadSpriteAtlasAsync(arg0:ResPath() .. "/" .. var0, "", function(arg0)
		arg0.imgName = var0
		arg0.image.sprite = arg0

		arg0.image:SetNativeSize()
		arg1()
	end)
end

function var0.InitSubImage(arg0)
	local var0 = arg0.config.text_pic

	setActive(arg0.subImage.gameObject, var0 ~= nil and var0 ~= "")

	if not var0 or var0 == arg0.subImgName then
		return
	end

	LoadSpriteAtlasAsync(arg0:ResPath() .. "/" .. var0, "", function(arg0)
		arg0.subImgName = var0
		arg0.subImage.sprite = arg0

		arg0.subImage:SetNativeSize()
	end)
end

function var0.GetTipImage(arg0)
	return "tip"
end

function var0.InitTipImage(arg0)
	local var0 = arg0:GetTipImage()

	if not var0 or var0 == arg0.tipImageName then
		return
	end

	LoadSpriteAtlasAsync("LinkButton/" .. var0, "", function(arg0)
		arg0.tipImageName = var0
		arg0.tipTr.sprite = arg0

		arg0.tipTr:SetNativeSize()
	end)
end

function var0.UpdatePosition(arg0, arg1)
	local var0 = -20
	local var1 = -150 - (arg1 - 1) * (arg0._tf.sizeDelta.y + var0)

	arg0._tf.anchoredPosition = Vector2(arg0._tf.anchoredPosition.x, var1, 0)
end

function var0.Clear(arg0)
	if arg0._tf then
		setActive(arg0._tf, false)
	end
end

function var0.emit(arg0, ...)
	arg0.event:emit(...)
end

function var0.Dispose(arg0)
	pg.DelegateInfo.Dispose(arg0)

	if arg0._tf then
		Destroy(arg0._tf.gameObject)

		arg0._tf = nil
	end
end

function var0.Skip(arg0, arg1)
	if arg1.type == GAMEUI_BANNER_1 then
		Application.OpenURL(arg1.param)
	elseif arg1.type == GAMEUI_BANNER_2 then
		arg0:emit(NewMainMediator.SKIP_SCENE, arg1.param)
	elseif arg1.type == GAMEUI_BANNER_3 then
		arg0:emit(NewMainMediator.SKIP_ACTIVITY, tonumber(arg1.param))
	elseif arg1.type == GAMEUI_BANNER_4 then
		arg0:emit(NewMainMediator.SKIP_SHOP, arg1.param)
	elseif arg1.type == GAMEUI_BANNER_5 then
		-- block empty
	elseif arg1.type == GAMEUI_BANNER_6 then
		arg0:emit(NewMainMediator.GO_SCENE, SCENE.SELTECHNOLOGY)
	elseif arg1.type == GAMEUI_BANNER_7 then
		arg0:emit(NewMainMediator.GO_MINI_GAME, arg1.param[1])
	elseif arg1.type == GAMEUI_BANNER_8 then
		if getProxy(GuildProxy):getRawData() then
			arg0:emit(NewMainMediator.GO_SCENE, SCENE.GUILD)
		else
			arg0:emit(NewMainMediator.GO_SCENE, SCENE.NEWGUILD)
		end
	end
end

function var0.ResPath(arg0)
	return "LinkButton"
end

function var0.GetActivityID(arg0)
	assert(false, "策划配置default类型 必须重写这个方法")
end

function var0.CustomOnClick(arg0)
	assert(false, "策划配置type = 0 这个按钮必须自己定义跳转行为")
end

function var0.GetEventName(arg0)
	assert(false, "overwrite me !!!")
end

function var0.OnInit(arg0)
	return
end

return var0

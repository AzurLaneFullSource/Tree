local var0_0 = class("MainBaseActivityBtn")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1, arg4_1)
	arg0_1.tpl = arg1_1

	pg.DelegateInfo.New(arg0_1)

	arg0_1.event = arg2_1
	arg0_1.hideSubImg = arg4_1

	if arg3_1 then
		arg0_1._tf = arg0_1.tpl
	end
end

function var0_0.GetLinkConfig(arg0_2)
	local var0_2 = arg0_2:GetEventName()
	local var1_2 = pg.activity_link_button
	local var2_2 = var1_2.get_id_list_by_name[var0_2] or {}
	local var3_2 = _.select(var2_2, function(arg0_3)
		local var0_3 = var1_2[arg0_3].time

		if type(var0_3) == "table" and var0_3[1] and var0_3[1] == "default" then
			return arg0_2:InActTime(var0_3[2])
		else
			return pg.TimeMgr.GetInstance():inTime(var0_3)
		end
	end)

	if #var3_2 > 0 then
		table.sort(var3_2, function(arg0_4, arg1_4)
			return var1_2[arg0_4].order < var1_2[arg1_4].order
		end)

		return var1_2[var3_2[1]]
	end
end

function var0_0.InActTime(arg0_5, arg1_5)
	local var0_5 = arg1_5 or arg0_5:GetActivityID()

	if var0_5 then
		local var1_5 = getProxy(ActivityProxy):getActivityById(var0_5)

		return var1_5 and not var1_5:isEnd()
	end

	return false
end

function var0_0.InShowTime(arg0_6)
	local var0_6 = arg0_6:GetLinkConfig()

	if var0_6 ~= nil then
		arg0_6.config = var0_6

		return true
	else
		return false
	end
end

function var0_0.NewGameObject(arg0_7)
	return arg0_7._tf or Object.Instantiate(arg0_7.tpl, arg0_7.tpl.parent).transform
end

function var0_0.Init(arg0_8, arg1_8)
	arg0_8._tf = arg0_8:NewGameObject()
	arg0_8._tf.gameObject.name = arg0_8.__cname
	arg0_8.image = arg0_8._tf:Find("Image"):GetComponent(typeof(Image))
	arg0_8.subImage = arg0_8._tf:Find("sub_Image"):GetComponent(typeof(Image))
	arg0_8.tipTr = arg0_8._tf:Find("Tip"):GetComponent(typeof(Image))
	arg0_8.tipTxt = arg0_8._tf:Find("Tip/Text"):GetComponent(typeof(Text))

	setActive(arg0_8._tf, true)

	arg0_8.tipTxt.text = ""

	arg0_8:InitTipImage()
	arg0_8:UpdatePosition(arg1_8)
	arg0_8:InitSubImage()
	arg0_8:InitImage(function()
		arg0_8:OnInit()
		arg0_8:Register()
	end)
end

function var0_0.Register(arg0_10)
	onButton(arg0_10, arg0_10._tf, function()
		if arg0_10.config.type <= 0 then
			arg0_10:CustomOnClick()
		else
			arg0_10:OnClick()
		end
	end, SFX_MAIN)
end

function var0_0.OnClick(arg0_12)
	var0_0.Skip(arg0_12, arg0_12.config)
end

function var0_0.InitImage(arg0_13, arg1_13)
	local var0_13 = arg0_13.config.pic

	if not var0_13 or var0_13 == arg0_13.imgName then
		arg1_13()

		return
	end

	arg0_13.imgName = var0_13

	LoadSpriteAtlasAsync(arg0_13:ResPath() .. "/" .. var0_13, "", function(arg0_14)
		if IsNil(arg0_13.image) then
			return
		end

		arg0_13.image.sprite = arg0_14

		arg0_13.image:SetNativeSize()
		arg1_13()
	end)
end

function var0_0.InitSubImage(arg0_15)
	if arg0_15.hideSubImg then
		setActive(arg0_15.subImage.gameObject, false)

		return
	end

	local var0_15 = arg0_15.config.text_pic

	setActive(arg0_15.subImage.gameObject, var0_15 ~= nil and var0_15 ~= "")

	if not var0_15 or var0_15 == arg0_15.subImgName then
		return
	end

	arg0_15.subImgName = var0_15

	GetImageSpriteFromAtlasAsync(arg0_15:ResPath() .. "/" .. var0_15, "", arg0_15.subImage, true)
end

function var0_0.GetTipImage(arg0_16)
	return "tip"
end

function var0_0.InitTipImage(arg0_17)
	local var0_17 = arg0_17:GetTipImage()

	if not var0_17 or var0_17 == arg0_17.tipImageName then
		return
	end

	arg0_17.tipImageName = var0_17

	GetImageSpriteFromAtlasAsync("LinkButton/" .. var0_17, "", arg0_17.tipTr, true)
end

function var0_0.UpdatePosition(arg0_18, arg1_18)
	local var0_18 = -20
	local var1_18 = -150 - (arg1_18 - 1) * (arg0_18._tf.sizeDelta.y + var0_18)

	arg0_18._tf.anchoredPosition = Vector2(arg0_18._tf.anchoredPosition.x, var1_18, 0)
end

function var0_0.Clear(arg0_19)
	if arg0_19._tf then
		setActive(arg0_19._tf, false)
	end
end

function var0_0.emit(arg0_20, ...)
	arg0_20.event:emit(...)
end

function var0_0.Dispose(arg0_21)
	pg.DelegateInfo.Dispose(arg0_21)

	if arg0_21._tf then
		Destroy(arg0_21._tf.gameObject)

		arg0_21._tf = nil
	end
end

function var0_0.Skip(arg0_22, arg1_22)
	if arg1_22.type == GAMEUI_BANNER_1 then
		Application.OpenURL(arg1_22.param)
	elseif arg1_22.type == GAMEUI_BANNER_2 then
		arg0_22:emit(NewMainMediator.SKIP_SCENE, arg1_22.param)
	elseif arg1_22.type == GAMEUI_BANNER_3 then
		arg0_22:emit(NewMainMediator.SKIP_ACTIVITY, tonumber(arg1_22.param))
	elseif arg1_22.type == GAMEUI_BANNER_4 then
		arg0_22:emit(NewMainMediator.SKIP_SHOP, arg1_22.param)
	elseif arg1_22.type == GAMEUI_BANNER_5 then
		-- block empty
	elseif arg1_22.type == GAMEUI_BANNER_6 then
		arg0_22:emit(NewMainMediator.GO_SCENE, SCENE.SELTECHNOLOGY)
	elseif arg1_22.type == GAMEUI_BANNER_7 then
		arg0_22:emit(NewMainMediator.GO_MINI_GAME, arg1_22.param[1])
	elseif arg1_22.type == GAMEUI_BANNER_8 then
		if getProxy(GuildProxy):getRawData() then
			arg0_22:emit(NewMainMediator.GO_SCENE, SCENE.GUILD)
		else
			arg0_22:emit(NewMainMediator.GO_SCENE, SCENE.NEWGUILD)
		end
	elseif arg1_22.type == GAMEUI_BANNER_14 then
		arg0_22:emit(NewMainMediator.OPEN_KINK_BUTTON_LAYER, Context.New({
			mediator = _G[arg1_22.param.mediator],
			viewComponent = _G[arg1_22.param.view]
		}))
	elseif arg1_22.type == GAMEUI_BANNER_15 then
		arg0_22:emit(NewMainMediator.SKIP_INS)
	end
end

function var0_0.ResPath(arg0_23)
	return "LinkButton"
end

function var0_0.GetActivityID(arg0_24)
	assert(false, "策划配置default类型 必须重写这个方法")
end

function var0_0.CustomOnClick(arg0_25)
	assert(false, "策划配置type = 0 这个按钮必须自己定义跳转行为")
end

function var0_0.GetEventName(arg0_26)
	assert(false, "overwrite me !!!")
end

function var0_0.OnInit(arg0_27)
	return
end

return var0_0

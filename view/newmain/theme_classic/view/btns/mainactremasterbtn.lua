local var0_0 = class("MainActRemasterBtn")

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
	return {
		param = "0",
		name = "event_actremaster",
		type = 3,
		text_pic = "text_event_all",
		id = 1,
		group_id = 1,
		pic = "event_actremaster",
		order = 1,
		time = {
			"default",
			51033
		}
	}
end

function var0_0.InShowTime(arg0_3)
	arg0_3.config = arg0_3:GetLinkConfig()

	return getProxy(ActivityRemasterProxy):ShouldShowActiveBtn()
end

function var0_0.NewGameObject(arg0_4)
	return arg0_4._tf or Object.Instantiate(arg0_4.tpl, arg0_4.tpl.parent).transform
end

function var0_0.Init(arg0_5, arg1_5)
	arg0_5._tf = arg0_5:NewGameObject()
	arg0_5._tf.gameObject.name = arg0_5.__cname
	arg0_5.image = arg0_5._tf:Find("Image"):GetComponent(typeof(Image))
	arg0_5.subImage = arg0_5._tf:Find("sub_Image"):GetComponent(typeof(Image))
	arg0_5.tipTr = arg0_5._tf:Find("Tip"):GetComponent(typeof(Image))
	arg0_5.tipTxt = arg0_5._tf:Find("Tip/Text"):GetComponent(typeof(Text))

	setActive(arg0_5._tf, true)

	arg0_5.tipTxt.text = ""

	arg0_5:InitTipImage()
	arg0_5:UpdatePosition(arg1_5)
	arg0_5:InitSubImage()
	arg0_5:InitImage(function()
		arg0_5:OnInit()
		arg0_5:Register()
	end)
end

function var0_0.Register(arg0_7)
	onButton(arg0_7, arg0_7._tf, function()
		arg0_7:emit(NewMainMediator.OPEN_ACT_REMASTER_SCENE)
	end, SFX_MAIN)
end

function var0_0.InitImage(arg0_9, arg1_9)
	local var0_9 = arg0_9.config.pic

	if not var0_9 or var0_9 == arg0_9.imgName then
		arg1_9()

		return
	end

	arg0_9.imgName = var0_9

	LoadSpriteAtlasAsync(arg0_9:ResPath() .. "/" .. var0_9, "", function(arg0_10)
		if IsNil(arg0_9.image) then
			return
		end

		arg0_9.image.sprite = arg0_10

		arg0_9.image:SetNativeSize()
		arg1_9()
	end)
end

function var0_0.InitSubImage(arg0_11)
	if arg0_11.hideSubImg then
		setActive(arg0_11.subImage.gameObject, false)

		return
	end

	local var0_11 = arg0_11.config.text_pic

	setActive(arg0_11.subImage.gameObject, var0_11 ~= nil and var0_11 ~= "")

	if not var0_11 or var0_11 == arg0_11.subImgName then
		return
	end

	arg0_11.subImgName = var0_11

	GetImageSpriteFromAtlasAsync(arg0_11:ResPath() .. "/" .. var0_11, "", arg0_11.subImage, true)
end

function var0_0.GetTipImage(arg0_12)
	return "tip"
end

function var0_0.InitTipImage(arg0_13)
	local var0_13 = arg0_13:GetTipImage()

	if not var0_13 or var0_13 == arg0_13.tipImageName then
		return
	end

	arg0_13.tipImageName = var0_13

	GetImageSpriteFromAtlasAsync("LinkButton/" .. var0_13, "", arg0_13.tipTr, true)
end

function var0_0.UpdatePosition(arg0_14, arg1_14)
	local var0_14 = -20
	local var1_14 = -150 - (arg1_14 - 1) * (arg0_14._tf.sizeDelta.y + var0_14)

	arg0_14._tf.anchoredPosition = Vector2(arg0_14._tf.anchoredPosition.x, var1_14, 0)
end

function var0_0.Clear(arg0_15)
	if arg0_15._tf then
		setActive(arg0_15._tf, false)
	end
end

function var0_0.emit(arg0_16, ...)
	arg0_16.event:emit(...)
end

function var0_0.Dispose(arg0_17)
	pg.DelegateInfo.Dispose(arg0_17)

	if arg0_17._tf then
		Destroy(arg0_17._tf.gameObject)

		arg0_17._tf = nil
	end
end

function var0_0.ResPath(arg0_18)
	return "LinkButton"
end

function var0_0.GetActivityID(arg0_19)
	assert(false, "策划配置default类型 必须重写这个方法")
end

function var0_0.CustomOnClick(arg0_20)
	assert(false, "策划配置type = 0 这个按钮必须自己定义跳转行为")
end

function var0_0.GetEventName(arg0_21)
	assert(false, "overwrite me !!!")
end

function var0_0.OnInit(arg0_22)
	setActive(arg0_22.tipTr.gameObject, true)
end

return var0_0

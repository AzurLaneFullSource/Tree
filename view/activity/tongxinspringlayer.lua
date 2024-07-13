local var0_0 = class("TongXinSpringLayer", import("..base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "TongXinSpringUI"
end

function var0_0.init(arg0_2)
	arg0_2.closedFlag = false
end

function var0_0.didEnter(arg0_3)
	arg0_3.ad = findTF(arg0_3._tf, "ad")
	arg0_3.animator = GetComponent(arg0_3.ad, typeof(Animator))
	arg0_3.dftAniEvent = GetComponent(arg0_3.ad, typeof(DftAniEvent))

	arg0_3.dftAniEvent:SetEndEvent(function()
		arg0_3:closeView()
	end)
	onButton(arg0_3, findTF(arg0_3._tf, "ad/clickClose"), function()
		if arg0_3.closedFlag then
			return
		end

		arg0_3.closedFlag = true

		arg0_3.animator:Play("anim_kinder_spring_out")
	end)
	onButton(arg0_3, findTF(arg0_3._tf, "ad/btnBack"), function()
		if arg0_3.closedFlag then
			return
		end

		arg0_3.closedFlag = true

		arg0_3.animator:Play("anim_kinder_spring_out")
	end)
	onButton(arg0_3, findTF(arg0_3._tf, "ad/btnHome"), function()
		arg0_3:emit(BaseUI.ON_HOME)
	end)
	pg.UIMgr.GetInstance():BlurPanel(arg0_3.ad)
	GetComponent(findTF(arg0_3.ad, "bg/img"), typeof(Image)):SetNativeSize()
	GetComponent(findTF(arg0_3.ad, "title/img"), typeof(Image)):SetNativeSize()
end

function var0_0.createUI(arg0_8)
	arg0_8.iconTpl = findTF(arg0_8._tf, "ad/list/iconTpl")

	setActive(arg0_8.iconTpl, false)

	arg0_8.iconContent = findTF(arg0_8._tf, "ad/list")

	local var0_8 = arg0_8.activity:GetTotalSlotCount()

	arg0_8.iconTfs = {}

	for iter0_8 = 1, var0_8 do
		local var1_8 = iter0_8
		local var2_8 = tf(instantiate(arg0_8.iconTpl))

		setActive(var2_8, true)
		SetParent(var2_8, arg0_8.iconContent)
		onButton(arg0_8, var2_8, function()
			arg0_8:clickIcon(var1_8)
		end)
		table.insert(arg0_8.iconTfs, var2_8)
	end
end

function var0_0.updateUI(arg0_10)
	local var0_10 = arg0_10.activity:GetShipIds()
	local var1_10 = arg0_10.activity:GetSlotCount()
	local var2_10 = arg0_10.activity:GetTotalSlotCount()

	for iter0_10 = 1, var2_10 do
		local var3_10 = arg0_10.iconTfs[iter0_10]
		local var4_10 = findTF(var3_10, "add")
		local var5_10 = findTF(var3_10, "lock")
		local var6_10 = findTF(var3_10, "char")

		setActive(var4_10, false)
		setActive(var5_10, false)
		setActive(var6_10, false)

		if iter0_10 <= var1_10 then
			if var0_10[iter0_10] and var0_10[iter0_10] ~= 0 then
				local var7_10 = getProxy(BayProxy):RawGetShipById(var0_10[iter0_10])

				if var7_10 then
					local var8_10 = LoadSprite("qicon/" .. var7_10:getPainting())

					setImageSprite(findTF(var6_10, "mask/icon"), var8_10)
					setActive(var6_10, true)
				else
					setActive(var4_10, true)
				end
			else
				setActive(var4_10, true)
			end
		else
			setActive(var5_10, true)
		end
	end
end

function var0_0.clickIcon(arg0_11, arg1_11)
	if arg1_11 <= arg0_11.activity:GetSlotCount() then
		local var0_11 = arg0_11.activity:GetShipIds()[arg1_11]
		local var1_11 = var0_11 > 0 and getProxy(BayProxy):RawGetShipById(var0_11)

		arg0_11:emit(TongXinSpringMediator.OPEN_CHUANWU, arg1_11, var1_11 and var1_11 or nil)
	else
		arg0_11:emit(TongXinSpringMediator.UNLOCK_SLOT, arg0_11.activity.id)
	end

	print("点击了第" .. arg1_11 .. "个")
end

function var0_0.InitActivity(arg0_12, arg1_12)
	arg0_12.activity = arg1_12

	arg0_12:createUI()
	arg0_12:updateUI()
end

function var0_0.UpdateActivity(arg0_13, arg1_13)
	arg0_13.activity = arg1_13

	arg0_13:updateUI()
end

function var0_0.willExit(arg0_14)
	arg0_14.dftAniEvent:SetEndEvent(nil)

	arg0_14.closedFlag = true

	pg.UIMgr.GetInstance():UnblurPanel(arg0_14.ad, arg0_14._tf)
end

function var0_0.onBackPressed(arg0_15)
	if arg0_15.closedFlag then
		return
	end

	arg0_15.closedFlag = true

	arg0_15.animator:Play("anim_kinder_spring_out")
end

return var0_0

local var0_0 = class("PlayerVitaeBaseBtn")

var0_0.HRZ_TYPE = 1
var0_0.VEC_TYPE = 2

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1.type = arg2_1 or var0_0.HRZ_TYPE
	arg0_1.tpl = arg1_1

	if isActive(arg1_1) then
		setActive(arg1_1, false)
	end

	arg0_1.isLoaded = false
	arg0_1.startPos = arg0_1.tpl.anchoredPosition
	arg0_1.tf = Object.Instantiate(arg0_1.tpl, arg0_1.tpl.parent).transform

	arg0_1:Hide()
end

function var0_0.IsHrzType(arg0_2)
	return arg0_2.type == var0_0.HRZ_TYPE
end

function var0_0.NewGo(arg0_3)
	local var0_3, var1_3 = arg0_3:GetBgName()
	local var2_3 = arg0_3.tf:GetComponent(typeof(Image))

	var2_3.sprite = LoadSprite("ui/" .. var0_3, var1_3)

	var2_3:SetNativeSize()
	arg0_3:Show()

	return arg0_3.tf
end

function var0_0.Load(arg0_4, arg1_4)
	pg.DelegateInfo.New(arg0_4)

	arg0_4.on = findTF(arg0_4.tf, "on")
	arg0_4.off = findTF(arg0_4.tf, "off")
	arg0_4.block = findTF(arg0_4.tf, "block")
	arg0_4.stateTr = findTF(arg0_4.tf, "state")
	arg0_4.onTxt = findTF(arg0_4.tf, "on_Text")
	arg0_4.offTxt = findTF(arg0_4.tf, "off_Text")

	arg0_4:InitBtn()

	arg0_4.isLoaded = true
end

function var0_0.IsActive(arg0_5)
	return false
end

function var0_0.Update(arg0_6, arg1_6, arg2_6, arg3_6)
	if not arg1_6 then
		arg0_6:Hide()

		return
	end

	arg0_6.index = arg2_6
	arg0_6.ship = arg3_6

	if not arg0_6.isLoaded then
		arg0_6:Load(arg0_6:NewGo())
	else
		if arg0_6.flag ~= arg0_6:GetDefaultValue() then
			arg0_6:InitBtn()
		end

		arg0_6:Show()
	end

	arg0_6:UpdatePosition()
end

function var0_0.UpdatePosition(arg0_7)
	if arg0_7:IsHrzType() then
		arg0_7:UpdatePositionForHrz()
	else
		arg0_7:UpdatePositionForVec()
	end
end

function var0_0.SwitchToVecLayout(arg0_8)
	local var0_8 = arg0_8.startPos
	local var1_8 = arg0_8.index
	local var2_8 = arg0_8.tf.sizeDelta.y
	local var3_8 = 20
	local var4_8 = (var1_8 - 1) * (var2_8 + var3_8) + var0_8.y

	arg0_8.tf.anchoredPosition = Vector2(var0_8.x, var4_8)
end

function var0_0.IsOverlap(arg0_9, arg1_9)
	local var0_9 = arg0_9.tf.rect.width * 0.5

	return arg1_9 < arg0_9.tf.localPosition.x + var0_9
end

function var0_0.UpdatePositionForHrz(arg0_10)
	local var0_10 = arg0_10.startPos
	local var1_10 = arg0_10.index
	local var2_10 = 0
	local var3_10 = 20

	if PLATFORM_CODE == PLATFORM_US then
		var2_10 = 310
		var3_10 = 10
	else
		var2_10 = arg0_10.tf.sizeDelta.x
	end

	local var4_10 = (var1_10 - 1) * (var2_10 + var3_10) + var0_10.x

	arg0_10.tf.anchorMax = Vector2(0, 0)
	arg0_10.tf.anchorMin = Vector2(0, 0)
	arg0_10.tf.anchoredPosition = Vector2(var4_10, var0_10.y)
end

function var0_0.UpdatePositionForVec(arg0_11)
	local var0_11 = arg0_11.startPos
	local var1_11 = arg0_11.index
	local var2_11 = arg0_11.tf.sizeDelta.y
	local var3_11 = 20
	local var4_11 = (var1_11 - 1) * (var2_11 + var3_11) + var0_11.y

	arg0_11.tf.anchorMax = Vector2(0, 1)
	arg0_11.tf.anchorMin = Vector2(0, 1)
	arg0_11.tf.anchoredPosition = Vector2(var0_11.x, var4_11)
end

local function var1_0(arg0_12, arg1_12)
	if arg0_12:IsHrzType() then
		arg0_12.block.anchoredPosition = arg1_12 and Vector2(-33, 0) or Vector2(-96, 0)
	else
		setActive(arg0_12.off, not arg1_12)
		setActive(arg0_12.on, arg1_12)

		local var0_12 = arg1_12 and "#FFFFFFFF" or "#5A6177"
		local var1_12 = arg1_12 and "#5A6177" or "#FFFFFFFF"

		arg0_12.onTxt:GetComponent(typeof(Text)).text = "<color=" .. var0_12 .. ">ON</color>"
		arg0_12.offTxt:GetComponent(typeof(Text)).text = "<color=" .. var1_12 .. ">OFF</color>"
	end
end

function var0_0.InitBtn(arg0_13)
	arg0_13.flag = arg0_13:GetDefaultValue()

	onButton(arg0_13, arg0_13.tf, function()
		if arg0_13:OnSwitch(not arg0_13.flag) then
			arg0_13.flag = not arg0_13.flag

			var1_0(arg0_13, arg0_13.flag)
			arg0_13:OnSwitchDone()
		end
	end, SFX_PANEL)
	arg0_13:UpdateBtnState(false, arg0_13.flag)
end

function var0_0.UpdateBtnState(arg0_15, arg1_15, arg2_15)
	setActive(arg0_15.on, not arg1_15)
	setActive(arg0_15.off, not arg1_15)

	if arg0_15:IsHrzType() then
		setActive(arg0_15.block, not arg1_15)
	end

	setActive(arg0_15.stateTr, arg1_15)

	if not arg1_15 then
		var1_0(arg0_15, arg2_15)
	end
end

function var0_0.Show(arg0_16)
	setActive(arg0_16.tf, true)
end

function var0_0.Hide(arg0_17)
	setActive(arg0_17.tf, false)
end

function var0_0.ShowOrHide(arg0_18, arg1_18)
	if arg1_18 then
		arg0_18:Show()
	else
		arg0_18:Hide()
	end
end

function var0_0.Dispose(arg0_19)
	if arg0_19.isLoaded then
		pg.DelegateInfo.Dispose(arg0_19)
		Object.Destroy(arg0_19.tf.gameObject)
	end

	arg0_19:OnDispose()
end

function var0_0.GetBgName(arg0_20)
	assert(false, "overwrite me !!!")
end

function var0_0.GetDefaultValue(arg0_21)
	assert(false, "overwrite me !!!")
end

function var0_0.OnSwitch(arg0_22, arg1_22)
	assert(false, "overwrite me !!!")
end

function var0_0.OnSwitchDone(arg0_23)
	return
end

function var0_0.OnDispose(arg0_24)
	return
end

function var0_0.setParent(arg0_25, arg1_25, arg2_25)
	SetParent(arg0_25.tf, arg1_25)
	arg0_25.tf:SetSiblingIndex(arg2_25)
end

return var0_0

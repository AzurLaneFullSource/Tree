local var0 = class("PlayerVitaeBaseBtn")

var0.HRZ_TYPE = 1
var0.VEC_TYPE = 2

function var0.Ctor(arg0, arg1, arg2)
	arg0.type = arg2 or var0.HRZ_TYPE
	arg0.tpl = arg1

	if isActive(arg1) then
		setActive(arg1, false)
	end

	arg0.isLoaded = false
	arg0.startPos = arg0.tpl.anchoredPosition
	arg0.tf = Object.Instantiate(arg0.tpl, arg0.tpl.parent).transform

	arg0:Hide()
end

function var0.IsHrzType(arg0)
	return arg0.type == var0.HRZ_TYPE
end

function var0.NewGo(arg0)
	local var0, var1 = arg0:GetBgName()
	local var2 = arg0.tf:GetComponent(typeof(Image))

	var2.sprite = LoadSprite("ui/" .. var0, var1)

	var2:SetNativeSize()
	arg0:Show()

	return arg0.tf
end

function var0.Load(arg0, arg1)
	pg.DelegateInfo.New(arg0)

	arg0.on = findTF(arg0.tf, "on")
	arg0.off = findTF(arg0.tf, "off")
	arg0.block = findTF(arg0.tf, "block")
	arg0.stateTr = findTF(arg0.tf, "state")
	arg0.onTxt = findTF(arg0.tf, "on_Text")
	arg0.offTxt = findTF(arg0.tf, "off_Text")

	arg0:InitBtn()

	arg0.isLoaded = true
end

function var0.IsActive(arg0)
	return false
end

function var0.Update(arg0, arg1, arg2, arg3)
	if not arg1 then
		arg0:Hide()

		return
	end

	arg0.index = arg2
	arg0.ship = arg3

	if not arg0.isLoaded then
		arg0:Load(arg0:NewGo())
	else
		if arg0.flag ~= arg0:GetDefaultValue() then
			arg0:InitBtn()
		end

		arg0:Show()
	end

	arg0:UpdatePosition()
end

function var0.UpdatePosition(arg0)
	if arg0:IsHrzType() then
		arg0:UpdatePositionForHrz()
	else
		arg0:UpdatePositionForVec()
	end
end

function var0.SwitchToVecLayout(arg0)
	local var0 = arg0.startPos
	local var1 = arg0.index
	local var2 = arg0.tf.sizeDelta.y
	local var3 = 20
	local var4 = (var1 - 1) * (var2 + var3) + var0.y

	arg0.tf.anchoredPosition = Vector2(var0.x, var4)
end

function var0.IsOverlap(arg0, arg1)
	local var0 = arg0.tf.rect.width * 0.5

	return arg1 < arg0.tf.localPosition.x + var0
end

function var0.UpdatePositionForHrz(arg0)
	local var0 = arg0.startPos
	local var1 = arg0.index
	local var2 = 0
	local var3 = 20

	if PLATFORM_CODE == PLATFORM_US then
		var2 = 310
		var3 = 10
	else
		var2 = arg0.tf.sizeDelta.x
	end

	local var4 = (var1 - 1) * (var2 + var3) + var0.x

	arg0.tf.anchorMax = Vector2(0, 0)
	arg0.tf.anchorMin = Vector2(0, 0)
	arg0.tf.anchoredPosition = Vector2(var4, var0.y)
end

function var0.UpdatePositionForVec(arg0)
	local var0 = arg0.startPos
	local var1 = arg0.index
	local var2 = arg0.tf.sizeDelta.y
	local var3 = 20
	local var4 = (var1 - 1) * (var2 + var3) + var0.y

	arg0.tf.anchorMax = Vector2(0, 1)
	arg0.tf.anchorMin = Vector2(0, 1)
	arg0.tf.anchoredPosition = Vector2(var0.x, var4)
end

local function var1(arg0, arg1)
	if arg0:IsHrzType() then
		arg0.block.anchoredPosition = arg1 and Vector2(-33, 0) or Vector2(-96, 0)
	else
		setActive(arg0.off, not arg1)
		setActive(arg0.on, arg1)

		local var0 = arg1 and "#FFFFFFFF" or "#5A6177"
		local var1 = arg1 and "#5A6177" or "#FFFFFFFF"

		arg0.onTxt:GetComponent(typeof(Text)).text = "<color=" .. var0 .. ">ON</color>"
		arg0.offTxt:GetComponent(typeof(Text)).text = "<color=" .. var1 .. ">OFF</color>"
	end
end

function var0.InitBtn(arg0)
	arg0.flag = arg0:GetDefaultValue()

	onButton(arg0, arg0.tf, function()
		if arg0:OnSwitch(not arg0.flag) then
			arg0.flag = not arg0.flag

			var1(arg0, arg0.flag)
			arg0:OnSwitchDone()
		end
	end, SFX_PANEL)
	arg0:UpdateBtnState(false, arg0.flag)
end

function var0.UpdateBtnState(arg0, arg1, arg2)
	setActive(arg0.on, not arg1)
	setActive(arg0.off, not arg1)

	if arg0:IsHrzType() then
		setActive(arg0.block, not arg1)
	end

	setActive(arg0.stateTr, arg1)

	if not arg1 then
		var1(arg0, arg2)
	end
end

function var0.Show(arg0)
	setActive(arg0.tf, true)
end

function var0.Hide(arg0)
	setActive(arg0.tf, false)
end

function var0.ShowOrHide(arg0, arg1)
	if arg1 then
		arg0:Show()
	else
		arg0:Hide()
	end
end

function var0.Dispose(arg0)
	if arg0.isLoaded then
		pg.DelegateInfo.Dispose(arg0)
		Object.Destroy(arg0.tf.gameObject)
	end

	arg0:OnDispose()
end

function var0.GetBgName(arg0)
	assert(false, "overwrite me !!!")
end

function var0.GetDefaultValue(arg0)
	assert(false, "overwrite me !!!")
end

function var0.OnSwitch(arg0, arg1)
	assert(false, "overwrite me !!!")
end

function var0.OnSwitchDone(arg0)
	return
end

function var0.OnDispose(arg0)
	return
end

function var0.setParent(arg0, arg1, arg2)
	SetParent(arg0.tf, arg1)
	arg0.tf:SetSiblingIndex(arg2)
end

return var0

local var0_0 = class("SculptureCard")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.tr = arg1_1
	arg0_1.go = arg1_1.gameObject
	arg0_1.nameImg = arg1_1:Find("name/Image"):GetComponent(typeof(Image))
	arg0_1.roleImg = arg1_1:Find("role"):GetComponent(typeof(Image))
	arg0_1.consumeTxt = arg1_1:Find("mask/Text"):GetComponent(typeof(Text))
	arg0_1.consumeIcon = arg1_1:Find("mask/icon"):GetComponent(typeof(Image))
	arg0_1.finishBtn = arg1_1:Find("btns/finish")
	arg0_1.continueBtn = arg1_1:Find("btns/continue")
	arg0_1.presentedBtn = arg1_1:Find("btns/presented")
	arg0_1.lockBtn = arg1_1:Find("mask")
end

function var0_0.Update(arg0_2, arg1_2, arg2_2)
	arg0_2.activity = arg2_2
	arg0_2.id = arg1_2

	local var0_2 = arg2_2:GetSculptureState(arg1_2)

	if var0_2 < SculptureActivity.STATE_UNLOCK then
		arg0_2:UpdateConsume()
	end

	arg0_2:UpdateName()
	arg0_2:UpdateRole(var0_2)
	arg0_2:UpdateBtns(var0_2)
end

function var0_0.Flush(arg0_3, arg1_3)
	arg0_3.activity = arg1_3

	local var0_3 = arg0_3.activity:GetSculptureState(arg0_3.id)

	arg0_3:UpdateBtns(var0_3)
	arg0_3:UpdateRole(var0_3)
end

function var0_0.UpdateConsume(arg0_4)
	local var0_4, var1_4 = arg0_4.activity:_GetComsume(arg0_4.id)

	arg0_4.consumeTxt.text = var1_4

	local var2_4 = var0_4
	local var3_4 = pg.activity_workbench_item[var2_4]

	arg0_4.consumeIcon.sprite = LoadSprite("props/" .. var3_4.icon)
	rtf(arg0_4.consumeIcon.gameObject).sizeDelta = Vector2(60, 60)
end

function var0_0.UpdateName(arg0_5)
	local var0_5 = arg0_5.activity:GetResorceName(arg0_5.id)

	arg0_5.nameImg.sprite = GetSpriteFromAtlas("ui/SculptureUI_atlas", var0_5 .. "_title")

	arg0_5.nameImg:SetNativeSize()
end

function var0_0.UpdateRole(arg0_6, arg1_6)
	local var0_6 = arg0_6.activity:GetResorceName(arg0_6.id)

	if arg1_6 == SculptureActivity.STATE_FINSIH then
		arg0_6.roleImg.sprite = nil

		setActive(arg0_6.roleImg.gameObject, false)
		arg0_6:LoadChar(var0_6)
	else
		if arg1_6 >= SculptureActivity.STATE_UNLOCK then
			var0_6 = var0_6 .. "_gray"
		end

		LoadSpriteAtlasAsync("SculptureRole/" .. var0_6, nil, function(arg0_7)
			if arg0_6.exited then
				return
			end

			arg0_6.roleImg.sprite = arg0_7

			arg0_6.roleImg:SetNativeSize()
		end)
	end
end

function var0_0.LoadChar(arg0_8, arg1_8)
	if arg0_8.charName == arg1_8 then
		return
	end

	arg0_8:ClearChar()
	PoolMgr.GetInstance():GetSpineChar("takegift_" .. arg1_8, true, function(arg0_9)
		arg0_9.transform:SetParent(arg0_8.roleImg.gameObject.transform.parent)

		arg0_9.transform.localScale = Vector3(0.8, 0.8, 0)
		arg0_9.transform.localPosition = Vector3(0, -180, 0)

		arg0_9:GetComponent(typeof(SpineAnimUI)):SetAction("take_wait_" .. arg1_8, 0)

		arg0_8.charGo = arg0_9
	end)

	arg0_8.charName = arg1_8
end

function var0_0.ClearChar(arg0_10)
	if arg0_10.charName and arg0_10.charGo then
		PoolMgr.GetInstance():ReturnSpineChar(arg0_10.charName, arg0_10.charGo)

		arg0_10.charName = nil
		arg0_10.charGo = nil
	end
end

function var0_0.UpdateBtns(arg0_11, arg1_11)
	setActive(arg0_11.finishBtn, arg1_11 == SculptureActivity.STATE_FINSIH)
	setActive(arg0_11.continueBtn, arg1_11 >= SculptureActivity.STATE_UNLOCK and arg1_11 < SculptureActivity.STATE_JOINT)
	setActive(arg0_11.presentedBtn, arg1_11 == SculptureActivity.STATE_JOINT)
	setActive(arg0_11.lockBtn, arg1_11 < SculptureActivity.STATE_UNLOCK)
end

function var0_0.Dispose(arg0_12)
	arg0_12.exited = true

	arg0_12:ClearChar()
end

return var0_0

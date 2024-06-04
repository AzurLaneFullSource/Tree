local var0 = class("SculptureCard")

function var0.Ctor(arg0, arg1)
	arg0.tr = arg1
	arg0.go = arg1.gameObject
	arg0.nameImg = arg1:Find("name/Image"):GetComponent(typeof(Image))
	arg0.roleImg = arg1:Find("role"):GetComponent(typeof(Image))
	arg0.consumeTxt = arg1:Find("mask/Text"):GetComponent(typeof(Text))
	arg0.consumeIcon = arg1:Find("mask/icon"):GetComponent(typeof(Image))
	arg0.finishBtn = arg1:Find("btns/finish")
	arg0.continueBtn = arg1:Find("btns/continue")
	arg0.presentedBtn = arg1:Find("btns/presented")
	arg0.lockBtn = arg1:Find("mask")
end

function var0.Update(arg0, arg1, arg2)
	arg0.activity = arg2
	arg0.id = arg1

	local var0 = arg2:GetSculptureState(arg1)

	if var0 < SculptureActivity.STATE_UNLOCK then
		arg0:UpdateConsume()
	end

	arg0:UpdateName()
	arg0:UpdateRole(var0)
	arg0:UpdateBtns(var0)
end

function var0.Flush(arg0, arg1)
	arg0.activity = arg1

	local var0 = arg0.activity:GetSculptureState(arg0.id)

	arg0:UpdateBtns(var0)
	arg0:UpdateRole(var0)
end

function var0.UpdateConsume(arg0)
	local var0, var1 = arg0.activity:_GetComsume(arg0.id)

	arg0.consumeTxt.text = var1

	local var2 = var0
	local var3 = pg.activity_workbench_item[var2]

	arg0.consumeIcon.sprite = LoadSprite("props/" .. var3.icon)
	rtf(arg0.consumeIcon.gameObject).sizeDelta = Vector2(60, 60)
end

function var0.UpdateName(arg0)
	local var0 = arg0.activity:GetResorceName(arg0.id)

	arg0.nameImg.sprite = GetSpriteFromAtlas("ui/SculptureUI_atlas", var0 .. "_title")

	arg0.nameImg:SetNativeSize()
end

function var0.UpdateRole(arg0, arg1)
	local var0 = arg0.activity:GetResorceName(arg0.id)

	if arg1 == SculptureActivity.STATE_FINSIH then
		arg0.roleImg.sprite = nil

		setActive(arg0.roleImg.gameObject, false)
		arg0:LoadChar(var0)
	else
		if arg1 >= SculptureActivity.STATE_UNLOCK then
			var0 = var0 .. "_gray"
		end

		LoadSpriteAtlasAsync("SculptureRole/" .. var0, nil, function(arg0)
			if arg0.exited then
				return
			end

			arg0.roleImg.sprite = arg0

			arg0.roleImg:SetNativeSize()
		end)
	end
end

function var0.LoadChar(arg0, arg1)
	if arg0.charName == arg1 then
		return
	end

	arg0:ClearChar()
	PoolMgr.GetInstance():GetSpineChar("takegift_" .. arg1, true, function(arg0)
		arg0.transform:SetParent(arg0.roleImg.gameObject.transform.parent)

		arg0.transform.localScale = Vector3(0.8, 0.8, 0)
		arg0.transform.localPosition = Vector3(0, -180, 0)

		arg0:GetComponent(typeof(SpineAnimUI)):SetAction("take_wait_" .. arg1, 0)

		arg0.charGo = arg0
	end)

	arg0.charName = arg1
end

function var0.ClearChar(arg0)
	if arg0.charName and arg0.charGo then
		PoolMgr.GetInstance():ReturnSpineChar(arg0.charName, arg0.charGo)

		arg0.charName = nil
		arg0.charGo = nil
	end
end

function var0.UpdateBtns(arg0, arg1)
	setActive(arg0.finishBtn, arg1 == SculptureActivity.STATE_FINSIH)
	setActive(arg0.continueBtn, arg1 >= SculptureActivity.STATE_UNLOCK and arg1 < SculptureActivity.STATE_JOINT)
	setActive(arg0.presentedBtn, arg1 == SculptureActivity.STATE_JOINT)
	setActive(arg0.lockBtn, arg1 < SculptureActivity.STATE_UNLOCK)
end

function var0.Dispose(arg0)
	arg0.exited = true

	arg0:ClearChar()
end

return var0

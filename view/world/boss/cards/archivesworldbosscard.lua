local var0 = class("ArchivesWorldBossCard")

function var0.Ctor(arg0, arg1)
	arg0._go = arg1
	arg0._tf = arg1.transform
	arg0.icon = arg0._tf:Find("icon"):GetComponent(typeof(Image))
	arg0.underwayTr = arg0._tf:Find("underway")
	arg0.staticTr = arg0._tf:Find("static")
	arg0.finishTr = arg0._tf:Find("finish")
	arg0.nameTxt = arg0._tf:Find("name"):GetComponent(typeof(Text))
	arg0.staticMaskTr = arg0._tf:Find("static_mask")
	arg0.uProgress = arg0.underwayTr:Find("progress/bar")
	arg0.uProgressTxt = arg0.underwayTr:Find("Text"):GetComponent(typeof(Text))
	arg0.sProgress = arg0.staticTr:Find("progress/bar")
	arg0.sProgressTxt = arg0.staticTr:Find("Text"):GetComponent(typeof(Text))
	arg0.fProgress = arg0.staticTr:Find("progress/bar")
	arg0.arrTr = arg0._tf:Find("arr")
	arg0.arrLpos = arg0.arrTr.localPosition
	arg0.sLabel = arg0.staticTr:Find("Text/label")
	arg0.sSynValue = arg0.staticTr:Find("Text1")
	arg0.sLabelLpos = arg0.sLabel.localPosition
	arg0.underwayLabelStr = i18n("meta_pt_point")

	setText(arg0.underwayTr:Find("label"), arg0.underwayLabelStr)
	setText(arg0.sLabel, i18n("meta_syn_rate"))

	arg0.tip = arg0._tf:Find("tip")

	setActive(arg0.arrTr, false)
end

function var0.Update(arg0, arg1)
	arg0.data = arg1
	arg0.bossId = arg1.id
	arg0.metaProgressVO = arg1.progress

	arg0:Flush()
end

function var0.Flush(arg0)
	local var0 = arg0.metaProgressVO
	local var1 = WorldBossConst.GetArchivesId()
	local var2 = arg0.bossId == var1 and WorldBossConst.GetAchieveState() ~= WorldBossConst.ACHIEVE_STATE_NOSTART
	local var3 = var0.metaPtData
	local var4 = not var3:CanGetNextAward()

	setActive(arg0.underwayTr, var2 and not var4)
	setActive(arg0.staticTr, not var2 and not var4)
	setActive(arg0.staticMaskTr, not var2 and not var4)
	setActive(arg0.finishTr, var4)

	local var5 = var3:GetResProgress()
	local var6 = var3:GetTotalResRequire()
	local var7 = var0.metaPtData.level + 1 > var0.unlockPTLevel
	local var8 = var0.id

	arg0.icon.sprite = GetSpriteFromAtlas("MetaWorldboss/" .. var8, "archives")
	arg0.sLabel.localPosition = Vector3(arg0.sLabel.localPosition.x, arg0.sLabelLpos.y, 0)

	if var4 then
		setFillAmount(arg0.fProgress, 1)
	elseif var2 then
		setFillAmount(arg0.uProgress, var5 / var6)
		setText(arg0.underwayTr:Find("label"), arg0.underwayLabelStr .. "(" .. var5 .. "/" .. var6 .. ")")
	else
		setText(arg0.underwayTr:Find("label"), arg0.underwayLabelStr)

		if var7 then
			arg0.sProgressTxt.enabled = false

			setText(arg0.staticTr:Find("label"), i18n("meta_pt_point"))
			setText(arg0.sLabel, i18n("meta_syn_finish"))
			setText(arg0.sSynValue, "(" .. var5 .. "/" .. var6 .. ")")

			arg0.sLabel.localPosition = Vector3(arg0.sLabel.localPosition.x, arg0.sLabelLpos.y + 20, 0)

			setFillAmount(arg0.sProgress, var5 / var6)
		else
			arg0.sProgressTxt.enabled = true

			setText(arg0.staticTr:Find("label"), "")
			setText(arg0.sSynValue, "")
			setText(arg0.sLabel, i18n("meta_syn_rate"))

			local var9 = math.min(1, var5 / var0.unlockPTNum)

			setFillAmount(arg0.sProgress, var9)

			arg0.sProgressTxt.text = string.format("%0.1f", var9 * 100) .. "%"
		end
	end

	local var10 = ShipGroup.getDefaultShipConfig(var0.id)

	arg0.nameTxt.text = var10.name

	setActive(arg0.tip, var3:CanGetAward())
end

function var0.Select(arg0)
	setActive(arg0.arrTr, true)
	LeanTween.value(arg0.arrTr.gameObject, arg0.arrLpos.x, arg0.arrLpos.x - 20, 0.9):setOnUpdate(System.Action_float(function(arg0)
		arg0.arrTr.localPosition = Vector3(arg0, arg0.arrLpos.y, 0)
	end)):setLoopPingPong()
end

function var0.UnSelect(arg0)
	setActive(arg0.arrTr, false)
	LeanTween.cancel(arg0.arrTr.gameObject)
end

function var0.Dispose(arg0)
	arg0:UnSelect()
end

return var0

local var0_0 = class("ArchivesWorldBossCard")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1._go = arg1_1
	arg0_1._tf = arg1_1.transform
	arg0_1.icon = arg0_1._tf:Find("icon"):GetComponent(typeof(Image))
	arg0_1.underwayTr = arg0_1._tf:Find("underway")
	arg0_1.staticTr = arg0_1._tf:Find("static")
	arg0_1.finishTr = arg0_1._tf:Find("finish")
	arg0_1.nameTxt = arg0_1._tf:Find("name"):GetComponent(typeof(Text))
	arg0_1.staticMaskTr = arg0_1._tf:Find("static_mask")
	arg0_1.uProgress = arg0_1.underwayTr:Find("progress/bar")
	arg0_1.uProgressTxt = arg0_1.underwayTr:Find("Text"):GetComponent(typeof(Text))
	arg0_1.sProgress = arg0_1.staticTr:Find("progress/bar")
	arg0_1.sProgressTxt = arg0_1.staticTr:Find("Text"):GetComponent(typeof(Text))
	arg0_1.fProgress = arg0_1.staticTr:Find("progress/bar")
	arg0_1.arrTr = arg0_1._tf:Find("arr")
	arg0_1.arrLpos = arg0_1.arrTr.localPosition
	arg0_1.sLabel = arg0_1.staticTr:Find("Text/label")
	arg0_1.sSynValue = arg0_1.staticTr:Find("Text1")
	arg0_1.sLabelLpos = arg0_1.sLabel.localPosition
	arg0_1.underwayLabelStr = i18n("meta_pt_point")

	setText(arg0_1.underwayTr:Find("label"), arg0_1.underwayLabelStr)
	setText(arg0_1.sLabel, i18n("meta_syn_rate"))

	arg0_1.tip = arg0_1._tf:Find("tip")

	setActive(arg0_1.arrTr, false)
end

function var0_0.Update(arg0_2, arg1_2)
	arg0_2.data = arg1_2
	arg0_2.bossId = arg1_2.id
	arg0_2.metaProgressVO = arg1_2.progress

	arg0_2:Flush()
end

function var0_0.Flush(arg0_3)
	local var0_3 = arg0_3.metaProgressVO
	local var1_3 = WorldBossConst.GetArchivesId()
	local var2_3 = arg0_3.bossId == var1_3 and WorldBossConst.GetAchieveState() ~= WorldBossConst.ACHIEVE_STATE_NOSTART
	local var3_3 = var0_3.metaPtData
	local var4_3 = not var3_3:CanGetNextAward()

	setActive(arg0_3.underwayTr, var2_3 and not var4_3)
	setActive(arg0_3.staticTr, not var2_3 and not var4_3)
	setActive(arg0_3.staticMaskTr, not var2_3 and not var4_3)
	setActive(arg0_3.finishTr, var4_3)

	local var5_3 = var3_3:GetResProgress()
	local var6_3 = var3_3:GetTotalResRequire()
	local var7_3 = var0_3.metaPtData.level + 1 > var0_3.unlockPTLevel
	local var8_3 = var0_3.id

	arg0_3.icon.sprite = GetSpriteFromAtlas("MetaWorldboss/" .. var8_3, "archives")
	arg0_3.sLabel.localPosition = Vector3(arg0_3.sLabel.localPosition.x, arg0_3.sLabelLpos.y, 0)

	if var4_3 then
		setFillAmount(arg0_3.fProgress, 1)
	elseif var2_3 then
		setFillAmount(arg0_3.uProgress, var5_3 / var6_3)
		setText(arg0_3.underwayTr:Find("label"), arg0_3.underwayLabelStr .. "(" .. var5_3 .. "/" .. var6_3 .. ")")
	else
		setText(arg0_3.underwayTr:Find("label"), arg0_3.underwayLabelStr)

		if var7_3 then
			arg0_3.sProgressTxt.enabled = false

			setText(arg0_3.staticTr:Find("label"), i18n("meta_pt_point"))
			setText(arg0_3.sLabel, i18n("meta_syn_finish"))
			setText(arg0_3.sSynValue, "(" .. var5_3 .. "/" .. var6_3 .. ")")

			arg0_3.sLabel.localPosition = Vector3(arg0_3.sLabel.localPosition.x, arg0_3.sLabelLpos.y + 20, 0)

			setFillAmount(arg0_3.sProgress, var5_3 / var6_3)
		else
			arg0_3.sProgressTxt.enabled = true

			setText(arg0_3.staticTr:Find("label"), "")
			setText(arg0_3.sSynValue, "")
			setText(arg0_3.sLabel, i18n("meta_syn_rate"))

			local var9_3 = math.min(1, var5_3 / var0_3.unlockPTNum)

			setFillAmount(arg0_3.sProgress, var9_3)

			arg0_3.sProgressTxt.text = string.format("%0.1f", var9_3 * 100) .. "%"
		end
	end

	local var10_3 = ShipGroup.getDefaultShipConfig(var0_3.id)

	arg0_3.nameTxt.text = var10_3.name

	setActive(arg0_3.tip, var3_3:CanGetAward())
end

function var0_0.Select(arg0_4)
	setActive(arg0_4.arrTr, true)
	LeanTween.value(arg0_4.arrTr.gameObject, arg0_4.arrLpos.x, arg0_4.arrLpos.x - 20, 0.9):setOnUpdate(System.Action_float(function(arg0_5)
		arg0_4.arrTr.localPosition = Vector3(arg0_5, arg0_4.arrLpos.y, 0)
	end)):setLoopPingPong()
end

function var0_0.UnSelect(arg0_6)
	setActive(arg0_6.arrTr, false)
	LeanTween.cancel(arg0_6.arrTr.gameObject)
end

function var0_0.Dispose(arg0_7)
	arg0_7:UnSelect()
end

return var0_0

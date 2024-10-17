pg = pg or {}
pg.RepairResMgr = singletonClass("RepairResMgr")

local var0_0 = pg.RepairResMgr

var0_0.TYPE_DEFAULT_RES = 2
var0_0.TYPE_L2D = 4
var0_0.TYPE_PAINTING = 8
var0_0.TYPE_CIPHER = 16

function var0_0.Init(arg0_1, arg1_1)
	LoadAndInstantiateAsync("ui", "RepairUI", function(arg0_2)
		arg0_1._go = arg0_2
		arg0_1._tf = arg0_1._go.transform

		arg0_1._go:SetActive(false)

		arg0_1.contentTxt = arg0_1._tf:Find("window/content/Text"):GetComponent(typeof(Text))
		arg0_1.parentTr = pg.UIMgr.GetInstance().OverlayToast

		arg0_1._go.transform:SetParent(arg0_1.parentTr, false)

		arg0_1.closeBtn = arg0_1._tf:Find("window/top/btnBack")
		arg0_1.btns = {
			arg0_1:InitDefaultResBtn(),
			arg0_1:InitL2dBtn(),
			arg0_1:InitPaintingBtn(),
			arg0_1:InitCipherBtn()
		}
		arg0_1.uiItemList = UIItemList.New(arg0_1._tf:Find("window/buttons"), arg0_1._tf:Find("window/buttons/custom_button_1"))

		setText(arg0_1._tf:Find("window/top/title"), i18n("msgbox_repair_title"))
		arg1_1()
	end, true, true)
end

function var0_0.InitDefaultResBtn(arg0_3)
	return {
		type = var0_0.TYPE_DEFAULT_RES,
		text = i18n("msgbox_repair"),
		onCallback = function()
			if PathMgr.FileExists(Application.persistentDataPath .. "/hashes.csv") then
				BundleWizard.Inst:GetGroupMgr("DEFAULT_RES"):StartVerifyForLua()
			else
				pg.TipsMgr.GetInstance():ShowTips(i18n("word_no_cache"))
			end
		end
	}
end

function var0_0.InitL2dBtn(arg0_5)
	return {
		type = var0_0.TYPE_L2D,
		text = i18n("msgbox_repair_l2d"),
		onCallback = function()
			if PathMgr.FileExists(Application.persistentDataPath .. "/hashes-live2d.csv") then
				BundleWizard.Inst:GetGroupMgr("L2D"):StartVerifyForLua()
			else
				pg.TipsMgr.GetInstance():ShowTips(i18n("word_no_cache"))
			end
		end
	}
end

function var0_0.InitPaintingBtn(arg0_7)
	return {
		type = var0_0.TYPE_PAINTING,
		text = i18n("msgbox_repair_painting"),
		onCallback = function()
			if PathMgr.FileExists(Application.persistentDataPath .. "/hashes-painting.csv") then
				BundleWizard.Inst:GetGroupMgr("PAINTING"):StartVerifyForLua()
			else
				pg.TipsMgr.GetInstance():ShowTips(i18n("word_no_cache"))
			end
		end
	}
end

function var0_0.InitCipherBtn(arg0_9)
	return {
		type = var0_0.TYPE_CIPHER,
		text = i18n("msgbox_repair_cipher"),
		onCallback = function()
			if PathMgr.FileExists(Application.persistentDataPath .. "/hashes-cipher.csv") then
				BundleWizard.Inst:GetGroupMgr("CIPHER"):StartVerifyForLua()
			else
				pg.TipsMgr.GetInstance():ShowTips(i18n("word_no_cache"))
			end
		end
	}
end

function var0_0.Repair(arg0_11, arg1_11)
	local var0_11 = arg1_11 or bit.bor(var0_0.TYPE_DEFAULT_RES, var0_0.TYPE_L2D, var0_0.TYPE_PAINTING, var0_0.TYPE_CIPHER)
	local var1_11 = {}

	for iter0_11, iter1_11 in ipairs(arg0_11.btns) do
		if bit.band(iter1_11.type, var0_11) > 0 then
			table.insert(var1_11, iter1_11)
		end
	end

	arg0_11:Show(var1_11)
end

function var0_0.Show(arg0_12, arg1_12)
	pg.DelegateInfo.New(arg0_12)
	arg0_12._go:SetActive(true)
	pg.UIMgr.GetInstance():BlurPanel(arg0_12._tf)
	arg0_12.uiItemList:make(function(arg0_13, arg1_13, arg2_13)
		if arg0_13 == UIItemList.EventUpdate then
			local var0_13 = arg1_12[arg1_13 + 1]

			setText(arg2_13:Find("Text"), var0_13.text)
			onButton(arg0_12, arg2_13, function()
				if var0_13.onCallback then
					var0_13.onCallback()
				end

				arg0_12:Hide()
			end, SFX_PANEL)
		end
	end)
	arg0_12.uiItemList:align(#arg1_12)

	arg0_12.contentTxt.text = i18n("resource_verify_warn")

	onButton(arg0_12, arg0_12._tf, function()
		arg0_12:Hide()
	end, SFX_PANEL)
	onButton(arg0_12, arg0_12.closeBtn, function()
		arg0_12:Hide()
	end, SFX_PANEL)
end

function var0_0.Hide(arg0_17)
	pg.DelegateInfo.Dispose(arg0_17)
	arg0_17._go:SetActive(false)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_17._tf, arg0_17.parentTr)
end

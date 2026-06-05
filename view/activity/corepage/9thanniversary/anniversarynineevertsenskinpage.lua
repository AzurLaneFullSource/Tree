local var0_0 = class("AnniversaryNineEvertsenSkinPage", import("view.activity.CorePage.9thAnniversary.AnniversaryNineHwahJahSkinPage"))

function var0_0.OnInit(arg0_1)
	arg0_1.bg = arg0_1._tf:Find("bg")
	arg0_1.dayTF = arg0_1.bg:Find("total_progress/day")
	arg0_1.maxDayTF = arg0_1.bg:Find("total_progress/max_day")
	arg0_1.item = arg0_1.bg:Find("item")
	arg0_1.items = arg0_1.bg:Find("items")
	arg0_1.uilist = UIItemList.New(arg0_1.items, arg0_1.item)
	arg0_1.btnDetail = arg0_1.bg:Find("btn_detail")
	arg0_1.txtDetail = arg0_1.btnDetail:Find("detail")
	arg0_1.btnStory = arg0_1.bg:Find("btn_story")
	arg0_1.taskWindow = AnniversaryNineEvertsenTaskWindow.New(arg0_1._tf, arg0_1.event)

	setActive(arg0_1.item, false)

	arg0_1.progressLabel = arg0_1.bg:Find("total_progress/label_1")

	setText(arg0_1.progressLabel, i18n("Outpost_20250904_Progress"))
	setText(arg0_1.txtDetail, i18n("Outpost_20260514_Detail"))
end

return var0_0

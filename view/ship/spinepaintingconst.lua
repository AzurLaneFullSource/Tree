local var0_0 = class("SpinePaintingConst")

var0_0.drag_type_normal = 1
var0_0.drag_type_rgb = 2
var0_0.drag_type_list = 3
var0_0.drag_type_once = 4
var0_0.drag_type_touch = 5
var0_0.ship_drag_datas = {
	gaoxiong_6 = {
		click_trigger = false,
		multiple_face = {},
		hit_area = {
			"drag"
		},
		drag_data = {
			type = 1,
			config_client = {
				{
					is_default = true,
					idle = "normal",
					action = "drag",
					change_idle = "ex"
				},
				{
					is_default = false,
					idle = "ex",
					action = "drag_ex",
					change_idle = "normal"
				}
			}
		}
	},
	jianye_5 = {
		click_trigger = false,
		multiple_face = {},
		hit_area = {
			"drag"
		},
		drag_data = {
			type = 1,
			config_client = {
				{
					is_default = true,
					idle = "normal",
					action = "drag",
					change_idle = "ex"
				},
				{
					is_default = false,
					idle = "ex",
					action = "drag_ex",
					change_idle = "normal"
				}
			}
		}
	},
	aimudeng_4 = {
		click_trigger = false,
		multiple_face = {
			name = {
				"aimudeng_4",
				"aimudeng_4M"
			},
			data = {
				{
					"normal",
					0
				},
				{
					"ex",
					5
				}
			}
		},
		hit_area = {
			"drag"
		},
		drag_data = {
			material = "SkeletonGraphicDefaultRGBSplit",
			type = 2,
			config_client = {
				{
					is_default = true,
					idle = "normal",
					action = "drag",
					change_idle = "ex"
				},
				{
					is_default = false,
					idle = "ex",
					action = "drag_ex",
					change_idle = "normal"
				}
			}
		}
	},
	yaerweite_2 = {
		click_trigger = true,
		multiple_face = {},
		drag_data = {},
		hit_area = {
			"drag"
		},
		drag_data = {
			type = 3,
			lock_layer = true,
			config_client = {
				"touch",
				"normal"
			}
		}
	},
	kaiersheng_3 = {
		click_trigger = true,
		multiple_face = {},
		hit_area = {
			"drag"
		},
		drag_data = {
			type = 1,
			config_client = {
				{
					is_default = true,
					idle = "normal",
					action = "drag",
					change_idle = "ex"
				},
				{
					is_default = false,
					idle = "ex",
					action = "drag_ex",
					change_idle = "normal"
				}
			}
		}
	},
	siwanshi_4 = {
		click_trigger = true,
		multiple_face = {},
		hit_area = {
			"touch_head",
			"touch_body",
			"touch_special",
			"touch_special_2",
			"touch_special_back"
		},
		action_enable = {
			"normal"
		},
		drag_data = {
			type = 1,
			config_client = {
				{
					change_idle = "normal",
					idle = "normal",
					action = "touch_body",
					is_default = true,
					event = "TouchBody",
					hit = "touch_body"
				},
				{
					change_idle = "normal",
					idle = "normal",
					action = "touch_body",
					is_default = true,
					event = "TouchHead",
					hit = "touch_head"
				},
				{
					change_idle = "touch_special_normal",
					idle = "normal",
					action = "touch_special",
					is_default = true,
					event = "TouchSpecial",
					hit = "touch_special"
				},
				{
					change_idle = "",
					idle = "touch_special_normal",
					action = "",
					is_default = false,
					event = "TouchSpecial",
					hit = "touch_special_2"
				},
				{
					change_idle = "normal",
					idle = "touch_special_normal",
					action = "touch_special_2",
					is_default = false,
					hit = "touch_special_back"
				}
			}
		}
	}
}
var0_0.ship_effect_action_able = {
	jianwu_3 = {
		"login"
	}
}

return var0_0

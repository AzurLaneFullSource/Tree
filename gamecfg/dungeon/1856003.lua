return {
	map_id = 10001,
	id = 1856003,
	stages = {
		{
			stageIndex = 1,
			failCondition = 1,
			timeCount = 300,
			passCondition = 1,
			backGroundStageID = 1,
			totalArea = {
				-80,
				20,
				90,
				70
			},
			playerArea = {
				-80,
				20,
				45,
				68
			},
			enemyArea = {},
			fleetCorrdinate = {
				-80,
				0,
				75
			},
			waves = {
				{
					triggerType = 1,
					waveIndex = 100,
					preWaves = {},
					triggerParams = {
						timeout = 0.5
					}
				},
				{
					triggerType = 3,
					waveIndex = 501,
					preWaves = {
						100
					},
					triggerParams = {
						id = "HUANXINGCANGHONGZHIYAN22-1"
					}
				},
				{
					triggerType = 0,
					key = true,
					waveIndex = 101,
					conditionType = 1,
					preWaves = {
						501
					},
					triggerParam = {},
					spawn = {
						{
							monsterTemplateID = 16666012,
							moveCast = true,
							delay = 0,
							score = 0,
							corrdinate = {
								0,
								0,
								75
							},
							buffList = {
								8001,
								8007,
								201134
							}
						},
						{
							monsterTemplateID = 16666013,
							moveCast = true,
							delay = 0,
							score = 0,
							corrdinate = {
								-10,
								0,
								65
							},
							buffList = {
								8001,
								8007
							}
						},
						{
							monsterTemplateID = 16666013,
							moveCast = true,
							delay = 0,
							score = 0,
							corrdinate = {
								-10,
								0,
								45
							},
							buffList = {
								8001,
								8007
							}
						},
						{
							monsterTemplateID = 16666012,
							moveCast = true,
							delay = 0,
							score = 0,
							corrdinate = {
								0,
								0,
								35
							},
							buffList = {
								8001,
								8007
							}
						}
					}
				},
				{
					triggerType = 0,
					key = true,
					waveIndex = 102,
					conditionType = 1,
					preWaves = {
						101
					},
					triggerParam = {},
					spawn = {
						{
							monsterTemplateID = 16666011,
							moveCast = true,
							delay = 0,
							score = 0,
							corrdinate = {
								0,
								0,
								80
							},
							buffList = {
								8001,
								8007
							}
						},
						{
							monsterTemplateID = 16666013,
							moveCast = true,
							delay = 0,
							score = 0,
							corrdinate = {
								-5,
								0,
								70
							},
							buffList = {
								8001,
								8007
							}
						},
						{
							monsterTemplateID = 16666013,
							moveCast = true,
							delay = 0,
							score = 0,
							corrdinate = {
								-5,
								0,
								40
							},
							buffList = {
								8001,
								8007
							}
						},
						{
							monsterTemplateID = 16666012,
							moveCast = true,
							delay = 0,
							score = 0,
							corrdinate = {
								0,
								0,
								30
							},
							buffList = {
								8001,
								8007
							}
						},
						{
							monsterTemplateID = 16666303,
							delay = 0.1,
							corrdinate = {
								-10,
								0,
								50
							},
							buffList = {},
							bossData = {
								hpBarNum = 50,
								icon = ""
							},
							buffList = {
								200914
							},
							phase = {
								{
									switchParam = 1,
									switchTo = 1,
									index = 0,
									switchType = 1,
									setAI = 20006
								},
								{
									index = 1,
									switchType = 1,
									switchTo = 2,
									switchParam = 7,
									addWeapon = {
										3202201,
										3202202
									}
								},
								{
									index = 2,
									switchParam = 2,
									switchTo = 3,
									switchType = 1,
									addWeapon = {
										3202205
									},
									removeWeapon = {
										3202201,
										3202202
									}
								},
								{
									index = 3,
									switchType = 1,
									switchTo = 4,
									switchParam = 11,
									addWeapon = {
										3202203,
										3202204
									}
								},
								{
									index = 4,
									switchParam = 2,
									switchTo = 5,
									switchType = 1,
									addWeapon = {
										3202206
									},
									removeWeapon = {
										3202203,
										3202204,
										3202205
									}
								},
								{
									index = 5,
									switchType = 1,
									switchTo = 6,
									switchParam = 10.5,
									addWeapon = {
										3202203,
										3202204
									}
								},
								{
									index = 6,
									switchType = 1,
									switchTo = 1,
									switchParam = 2.5,
									removeWeapon = {
										3202203,
										3202204,
										3202206
									}
								}
							}
						}
					}
				},
				{
					triggerType = 3,
					waveIndex = 502,
					preWaves = {
						102
					},
					triggerParams = {
						id = "HUANXINGCANGHONGZHIYAN22-2"
					}
				},
				{
					triggerType = 0,
					key = true,
					waveIndex = 103,
					conditionType = 1,
					preWaves = {
						502
					},
					triggerParam = {},
					spawn = {
						{
							monsterTemplateID = 16666305,
							reinforceDelay = 3,
							delay = 0,
							corrdinate = {
								5,
								0,
								30
							},
							buffList = {
								200607,
								200914
							},
							bossData = {
								hpBarNum = 10,
								icon = "",
								hideBarNum = true
							},
							phase = {
								{
									switchType = 1,
									switchTo = 1,
									index = 0,
									switchParam = 8.5,
									setAI = 20006,
									addWeapon = {}
								},
								{
									switchParam = 300,
									switchTo = 2,
									index = 1,
									switchType = 1,
									setAI = 70232,
									addBuff = {
										200997
									},
									addWeapon = {
										3183201
									},
									removeWeapon = {}
								},
								{
									index = 11,
									switchParam = 3,
									switchTo = 1,
									switchType = 1,
									addWeapon = {},
									removeWeapon = {
										3183201
									}
								},
								{
									index = 21,
									switchParam = 8,
									switchTo = 22,
									switchType = 1,
									addWeapon = {
										3183202
									},
									removeWeapon = {
										3183201
									}
								},
								{
									index = 22,
									switchType = 1,
									switchTo = 1,
									switchParam = 1,
									removeWeapon = {
										3183202
									}
								}
							}
						},
						{
							monsterTemplateID = 16666304,
							delay = 0,
							corrdinate = {
								-20,
								0,
								50
							},
							buffList = {
								200612,
								201134
							},
							bossData = {
								hpBarNum = 80,
								icon = ""
							},
							phase = {
								{
									switchParam = 8.5,
									switchTo = 1,
									index = 0,
									switchType = 1,
									setAI = 70231
								},
								{
									switchType = 1,
									switchTo = 2,
									index = 1,
									switchParam = 7,
									setAI = 10001,
									addWeapon = {
										3183205,
										3183206
									}
								},
								{
									switchType = 1,
									switchTo = 3,
									index = 2,
									switchParam = 1.5,
									setAI = 70231,
									removeWeapon = {
										3183205,
										3183206
									}
								},
								{
									index = 3,
									switchType = 1,
									switchTo = 4,
									switchParam = 9,
									addWeapon = {
										3183207,
										3183208
									}
								},
								{
									index = 4,
									switchType = 1,
									switchTo = 5,
									switchParam = 1.5,
									removeWeapon = {
										3183207,
										3183208
									}
								},
								{
									switchType = 1,
									switchTo = 6,
									index = 5,
									switchParam = 4,
									setAI = 10001,
									addWeapon = {
										3183209
									}
								},
								{
									switchType = 1,
									switchTo = 7,
									index = 6,
									switchParam = 2,
									setAI = 70231,
									addWeapon = {
										3183210
									},
									removeWeapon = {
										3183209
									}
								},
								{
									index = 7,
									switchType = 1,
									switchTo = 8,
									switchParam = 18,
									addWeapon = {
										3183211
									}
								},
								{
									index = 8,
									switchType = 1,
									switchTo = 1,
									switchParam = 3,
									removeWeapon = {
										3183210,
										3183211
									}
								}
							}
						}
					},
					reinforcement = {
						{
							monsterTemplateID = 16666101,
							moveCast = true,
							delay = 0,
							score = 0,
							corrdinate = {
								-5,
								0,
								75
							},
							buffList = {
								8001,
								8007
							}
						},
						{
							monsterTemplateID = 16666103,
							moveCast = true,
							delay = 0,
							score = 0,
							corrdinate = {
								-15,
								0,
								50
							},
							buffList = {
								8001,
								8007
							}
						},
						{
							monsterTemplateID = 16666102,
							moveCast = true,
							delay = 0,
							score = 0,
							corrdinate = {
								-5,
								0,
								25
							},
							buffList = {
								8001,
								8007
							}
						}
					}
				},
				{
					triggerType = 8,
					waveIndex = 900,
					preWaves = {
						103
					},
					triggerParams = {}
				},
				{
					triggerType = 3,
					key = true,
					waveIndex = 503,
					preWaves = {
						900
					},
					triggerParams = {
						id = "HUANXINGCANGHONGZHIYAN22-3"
					}
				}
			}
		}
	},
	fleet_prefab = {
		vanguard_unitList = {
			{
				tmpID = 900457,
				configId = 900457,
				skinId = 9701060,
				id = 1,
				level = 125,
				equipment = {
					false,
					false,
					false
				},
				properties = {
					cannon = 200,
					air = 0,
					antiaircraft = 200,
					torpedo = 200,
					durability = 30000,
					reload = 500,
					armor = 0,
					dodge = 30,
					speed = 30,
					luck = 99,
					hit = 150
				},
				skills = {
					{
						id = 801320,
						level = 10
					},
					{
						id = 801330,
						level = 10
					},
					{
						id = 801342,
						level = 10
					}
				}
			},
			{
				tmpID = 900458,
				configId = 900458,
				skinId = 9702050,
				id = 2,
				level = 125,
				equipment = {
					false,
					false,
					false
				},
				properties = {
					cannon = 200,
					air = 0,
					antiaircraft = 200,
					torpedo = 200,
					durability = 30000,
					reload = 500,
					armor = 0,
					dodge = 30,
					speed = 30,
					luck = 99,
					hit = 150
				},
				skills = {
					{
						id = 800920,
						level = 10
					},
					{
						id = 800930,
						level = 10
					},
					{
						id = 800940,
						level = 10
					},
					{
						id = 800952,
						level = 10
					}
				}
			}
		},
		main_unitList = {
			{
				tmpID = 900459,
				configId = 900459,
				skinId = 9705060,
				id = 1,
				level = 125,
				equipment = {
					false,
					false,
					false
				},
				properties = {
					cannon = 500,
					air = 500,
					antiaircraft = 250,
					torpedo = 0,
					durability = 20000,
					reload = 800,
					armor = 0,
					dodge = 50,
					speed = 20,
					luck = 99,
					hit = 150
				},
				skills = {
					{
						id = 801350,
						level = 10
					},
					{
						id = 801360,
						level = 10
					},
					{
						id = 801370,
						level = 10
					},
					{
						id = 801382,
						level = 10
					},
					{
						id = 2,
						level = 10
					},
					{
						id = 340,
						level = 10
					}
				}
			}
		}
	}
}

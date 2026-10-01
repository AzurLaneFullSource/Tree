return {
	id = "DORM3DVIDEO2201",
	mode = 2,
	shipGroup = 20707,
	label = "dorm3d_VIDEO_CHAT_LABEL",
	scripts = {
		{
			say = "Do you have a moment, Commander?",
			wait = 1,
			voice = "event:/dorm/dorm3d_implacable_telephone1/dorm3d_implacable_telephone1",
			dispatcher = {
				name = STORY_EVENT.TEST,
				data = {
					op_list = {
						{
							param = "Play",
							name = "anger_01-start",
							time = 0,
							type = "action",
							skip = true
						},
						{
							skip = true,
							name = "Face_smile_start",
							type = "action"
						},
						{
							skip = false,
							time = 3,
							type = "wait"
						}
					}
				},
				callbackData = {
					hideUI = false,
					name = STORY_EVENT.TEST_DONE
				}
			}
		},
		{
			say = "I was just praying for you when I realised something.",
			wait = 1,
			voice = "event:/dorm/dorm3d_implacable_telephone2/dorm3d_implacable_telephone2",
			dispatcher = {
				name = STORY_EVENT.TEST,
				data = {
					op_list = {
						{
							param = "Play",
							name = "Idle",
							time = 0,
							type = "action",
							skip = true
						},
						{
							skip = true,
							name = "Face_amazed_start",
							type = "action"
						},
						{
							skip = false,
							time = 3,
							type = "wait"
						}
					}
				},
				callbackData = {
					hideUI = false,
					name = STORY_EVENT.TEST_DONE
				}
			}
		},
		{
			say = "Recently, I've been trying a new stew recipe...",
			wait = 1,
			voice = "event:/dorm/dorm3d_implacable_telephone3/dorm3d_implacable_telephone3",
			dispatcher = {
				name = STORY_EVENT.TEST,
				data = {
					op_list = {
						{
							param = "Play",
							name = "think_01-start",
							time = 0,
							type = "action",
							skip = true
						},
						{
							skip = true,
							name = "Face_think_start",
							type = "action"
						},
						{
							skip = false,
							time = 3,
							type = "wait"
						}
					}
				},
				callbackData = {
					hideUI = false,
					name = STORY_EVENT.TEST_DONE
				}
			}
		},
		{
			say = "I only need one portion, but I seem to often end up with more than that.",
			wait = 1,
			voice = "event:/dorm/dorm3d_implacable_telephone4/dorm3d_implacable_telephone4",
			dispatcher = {
				name = STORY_EVENT.TEST,
				data = {
					op_list = {
						{
							param = "Play",
							name = "Idle",
							time = 0,
							type = "action",
							skip = true
						},
						{
							skip = true,
							name = "Face_common",
							type = "action"
						},
						{
							skip = false,
							time = 3,
							type = "wait"
						}
					}
				},
				callbackData = {
					hideUI = false,
					name = STORY_EVENT.TEST_DONE
				}
			}
		},
		{
			say = "And so, if you'd like...",
			wait = 1,
			voice = "event:/dorm/dorm3d_implacable_telephone5/dorm3d_implacable_telephone5",
			dispatcher = {
				name = STORY_EVENT.TEST,
				data = {
					op_list = {
						{
							param = "Play",
							name = "pray_01-start",
							time = 0,
							type = "action",
							skip = true
						},
						{
							skip = true,
							name = "Face_think_start",
							type = "action"
						},
						{
							skip = false,
							time = 1,
							type = "wait"
						}
					}
				},
				callbackData = {
					hideUI = false,
					name = STORY_EVENT.TEST_DONE
				}
			}
		},
		{
			say = "You could share in this sinful indulgence with me once in a while.",
			wait = 1,
			voice = "event:/dorm/dorm3d_implacable_telephone6/dorm3d_implacable_telephone6",
			options = {
				{
					content = "Stew? Sounds good.",
					flag = 1
				}
			},
			dispatcher = {
				name = STORY_EVENT.TEST,
				data = {
					op_list = {
						{
							param = "Play",
							name = "Idle",
							time = 0,
							type = "action",
							skip = true
						},
						{
							skip = true,
							name = "Face_common",
							type = "action"
						},
						{
							skip = false,
							time = 3,
							type = "wait"
						}
					}
				},
				callbackData = {
					hideUI = false,
					name = STORY_EVENT.TEST_DONE
				}
			}
		},
		{
			say = "Heehee... Although, I'm still not certain about the seasoning.",
			wait = 1,
			voice = "event:/dorm/dorm3d_implacable_telephone7/dorm3d_implacable_telephone7",
			dispatcher = {
				name = STORY_EVENT.TEST,
				data = {
					op_list = {
						{
							param = "Play",
							name = "doubt_01-start",
							time = 0,
							type = "action",
							skip = true
						},
						{
							skip = true,
							name = "Face_think_start",
							type = "action"
						},
						{
							skip = false,
							time = 3,
							type = "wait"
						}
					}
				},
				callbackData = {
					hideUI = false,
					name = STORY_EVENT.TEST_DONE
				}
			}
		},
		{
			say = "And while it shames me to admit it, I don't know all that much about your preferences yet either, Commander.",
			wait = 1,
			voice = "event:/dorm/dorm3d_implacable_telephone8/dorm3d_implacable_telephone8"
		},
		{
			say = "Do you prefer a deeper or more delicate flavour?",
			wait = 2,
			voice = "event:/dorm/dorm3d_implacable_telephone9/dorm3d_implacable_telephone9",
			dispatcher = {
				name = STORY_EVENT.TEST,
				data = {
					op_list = {
						{
							param = "Play",
							name = "hello_01-start",
							time = 0,
							type = "action",
							skip = true
						},
						{
							skip = true,
							name = "Face_think_start",
							type = "action"
						},
						{
							skip = false,
							time = 3,
							type = "wait"
						}
					}
				},
				callbackData = {
					hideUI = false,
					name = STORY_EVENT.TEST_DONE
				}
			}
		},
		{
			say = "Or perhaps you'd like to try something just a touch more...dangerous? I made it specially...and I DO recommend it.",
			wait = 2,
			voice = "event:/dorm/dorm3d_implacable_telephone10/dorm3d_implacable_telephone10",
			options = {
				{
					content = "It's hard to choose. Can I try them all?",
					flag = 1
				}
			},
			dispatcher = {
				name = STORY_EVENT.TEST,
				data = {
					op_list = {
						{
							param = "Play",
							name = "happy_01-start",
							time = 0,
							type = "action",
							skip = true
						},
						{
							skip = true,
							name = "Face_smile_start",
							type = "action"
						},
						{
							skip = false,
							time = 3,
							type = "wait"
						}
					}
				},
				callbackData = {
					hideUI = false,
					name = STORY_EVENT.TEST_DONE
				}
			}
		},
		{
			say = "Heehee, aren't you greedy? Your honesty with your desires is really very stirring.",
			wait = 1,
			voice = "event:/dorm/dorm3d_implacable_telephone11/dorm3d_implacable_telephone11",
			dispatcher = {
				name = STORY_EVENT.TEST,
				data = {
					op_list = {
						{
							param = "Play",
							name = "anger_01-start",
							time = 0,
							type = "action",
							skip = true
						},
						{
							skip = true,
							name = "Face_helpless_start",
							type = "action"
						},
						{
							skip = false,
							time = 3,
							type = "wait"
						}
					}
				},
				callbackData = {
					hideUI = false,
					name = STORY_EVENT.TEST_DONE
				}
			}
		},
		{
			say = "So, would you come by tonight?",
			wait = 1,
			voice = "event:/dorm/dorm3d_implacable_telephone12/dorm3d_implacable_telephone12",
			dispatcher = {
				name = STORY_EVENT.TEST,
				data = {
					op_list = {
						{
							param = "Play",
							name = "talk_01-start",
							time = 0,
							type = "action",
							skip = true
						},
						{
							skip = true,
							name = "Face_shame_start",
							type = "action"
						},
						{
							skip = false,
							time = 3,
							type = "wait"
						}
					}
				},
				callbackData = {
					hideUI = false,
					name = STORY_EVENT.TEST_DONE
				}
			}
		},
		{
			say = "I'll make sure it's all ready for you. And then...",
			wait = 1,
			voice = "event:/dorm/dorm3d_implacable_telephone13/dorm3d_implacable_telephone13",
			dispatcher = {
				name = STORY_EVENT.TEST,
				data = {
					op_list = {
						{
							param = "Play",
							name = "hug_01-start",
							time = 0,
							type = "action",
							skip = true
						},
						{
							skip = true,
							name = "Face_shy_start",
							type = "action"
						},
						{
							skip = false,
							time = 3,
							type = "wait"
						}
					}
				},
				callbackData = {
					hideUI = false,
					name = STORY_EVENT.TEST_DONE
				}
			}
		},
		{
			say = "While you're tasting it, I'll take my time to drink in the expressions you make, and every exhalation that leaves you.",
			wait = 1,
			voice = "event:/dorm/dorm3d_implacable_telephone14/dorm3d_implacable_telephone14",
			dispatcher = {
				name = STORY_EVENT.TEST,
				data = {
					op_list = {
						{
							param = "Play",
							name = "answer_01-start",
							time = 0,
							type = "action",
							skip = true
						},
						{
							skip = true,
							name = "Face_shy_start",
							type = "action"
						},
						{
							skip = false,
							time = 3,
							type = "wait"
						}
					}
				},
				callbackData = {
					hideUI = false,
					name = STORY_EVENT.TEST_DONE
				}
			}
		},
		{
			say = "I want you to tell me the true flavour you seek, in the warm candlelight.",
			wait = 2,
			voice = "event:/dorm/dorm3d_implacable_telephone15/dorm3d_implacable_telephone15",
			dispatcher = {
				name = STORY_EVENT.TEST,
				data = {
					op_list = {
						{
							param = "Play",
							name = "Idle",
							time = 0,
							type = "action",
							skip = true
						},
						{
							skip = true,
							name = "Face_shy_start",
							type = "action"
						},
						{
							skip = false,
							time = 3,
							type = "wait"
						}
					}
				},
				callbackData = {
					hideUI = false,
					name = STORY_EVENT.TEST_DONE
				}
			}
		},
		{
			say = "Wrapped in fragrances and whispers...",
			wait = 2,
			voice = "event:/dorm/dorm3d_implacable_telephone16/dorm3d_implacable_telephone16",
			dispatcher = {
				name = STORY_EVENT.TEST,
				data = {
					op_list = {
						{
							param = "Play",
							name = "Idle",
							time = 0,
							type = "action",
							skip = true
						},
						{
							skip = true,
							name = "Face_common",
							type = "action"
						},
						{
							skip = false,
							time = 3,
							type = "wait"
						}
					}
				},
				callbackData = {
					hideUI = false,
					name = STORY_EVENT.TEST_DONE
				}
			}
		},
		{
			say = "Let's seek something that satisfies both our palates and our hearts...",
			wait = 2,
			voice = "event:/dorm/dorm3d_implacable_telephone17/dorm3d_implacable_telephone17",
			dispatcher = {
				name = STORY_EVENT.TEST,
				data = {
					op_list = {
						{
							param = "Play",
							name = "heart_01-start",
							time = 0,
							type = "action",
							skip = true
						},
						{
							skip = true,
							name = "Face_shy_start",
							type = "action"
						},
						{
							skip = false,
							time = 3,
							type = "wait"
						}
					}
				},
				callbackData = {
					hideUI = false,
					name = STORY_EVENT.TEST_DONE
				}
			}
		}
	}
}

local styles = data.raw["gui-style"].default
styles["apl_content_frame"] = {
    type = "frame_style",
    parent = "inside_shallow_frame_with_padding",
    vertically_stretchable = "on"
}

styles["apl_scroll_pane"] = {
    type = "scroll_pane_style",
    parent = "scroll_pane",
    vertically_stretchable = "on"
}

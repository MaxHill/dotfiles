# 32-Key Split Keyboard Layout - Quick Reference

## Activation

**Enable experimental layout:**
```bash
just kanata-experimental
```

**Return to normal layout:**
```bash
just kanata-normal
```

**Check status:**
```bash
just keyboard-status
just kanata-errors
```

---

## Physical Layout

Your right hand is shifted 2 keys to the right. Physical keys vs output:

### What You Press (Swedish Keycaps)
```
Left:   Q W E R T  /  A S D F G  /  Z X C V B
Right:  Y U I O P  /  L Ö Ä '    /  N M , . /
Thumbs: Option | Cmd  /  Cmd | Option
```

### What Gets Output (QWERTY)
```
Left:   Q W E R T  /  A S D F G  /  Z X C V B
Right:  Y U I O P  /  J K L ;    /  N M , . /
Thumbs: Esc/Opt | Space/NumNav  /  Enter/Sym | Bspc/Caps
```

---

## 4 Layers

### 1. Base Layer (Default)
- **Letters:** Normal QWERTY (with right hand shift)
- **Homerow Mods:** Hold 200ms to activate modifier
  - Left: `D`=Shift, `F`=Alt, `G`=Cmd
  - Right: `J`=Cmd, `K`=Alt, `L`=Shift
- **Disabled:** Number row, Tab, Shifts, Brackets, etc.
- **Enabled:** Media keys (brightness F1-F2, volume F10-F12, media F7-F9)

### 2. Symbol Layer (Hold Enter)
```
Top row:  ! @ # $ %  ^  & * ( )
Home row: + [ { ( =  _  ) } ] :
Bot row:  ~ - + `  |  < > ? "
```

### 3. NumNav Layer (Hold Space)
```
Top row:  1 2 3 4 5  6 7 8 9 0
Home row: _ _ _ _ _  ← ↓ ↑ →    (vim arrows on J K L ;)
Bot row:  _ _ _ _ _  Home PgDn PgUp End
```

### 4. Caps Layer (Hold Backspace)
- All letters output their SHIFTED version (capitals)
- Makes typing FULL_CAPS easy without homerow Shift

---

## Thumb Keys (Tap-Hold 200ms)

| Physical Key | Tap | Hold |
|--------------|-----|------|
| **Left Option** | Esc | Left-Option (passthrough) |
| **Left Cmd** | Space | NumNav layer |
| **Right Cmd** | Enter | Symbol layer |
| **Right Option** | Backspace | Caps layer |

---

## Common Operations

### Typing
- **Capital letter:** Hold `D` or `L` + tap letter (homerow Shift)
- **Word in CAPS:** Hold Backspace + type word (Caps layer)

### Navigation
- **Arrow keys:** Hold Space, use `J` `K` `L` `;` (←↓↑→)
- **Page nav:** Hold Space, use `N`=Home, `M`=PgDn, `,`=PgUp, `.`=End

### Numbers
- **Type numbers:** Hold Space, tap QWERTY row (`Q`-`P` = 1-0)

### Symbols
- **Parentheses:** Hold Enter, tap `(` `)` on homerow
- **Brackets:** Hold Enter, tap `[` `{` on homerow
- **Common symbols:** Hold Enter, use homerow (see Symbol layer map)

### Shortcuts
- **Cmd+C (copy):** Hold `G` + tap `C`
- **Cmd+V (paste):** Hold `G` + tap `V`
- **Alt+Tab:** Hold `F` + tap Tab... wait, Tab is disabled!
- **Workaround:** Use physical modifiers or remap if needed

---

## Troubleshooting

### Homerow mods triggering accidentally
- **Issue:** Typing fast triggers mods instead of letters
- **Fix 1:** Increase timing to 250ms in config (line ~188)
- **Fix 2:** Type more deliberately with clear tap/hold distinction

### Right hand keys output wrong letters
- **Issue:** Physical `L` outputs `L` instead of `J`
- **Cause:** Physical remapping not working
- **Debug:** Check which keys are being pressed vs output

### Can't type numbers
- **Remember:** Hold Space (Left-Cmd thumb), then tap QWERTY row
- **Not:** Number row is disabled in strict 32-key mode

### Media keys not working
- **Check:** F1-F2 (brightness), F7-F9 (media), F10-F12 (volume)
- **These should work** even in experimental mode

### Need to exit experimental mode
```bash
just kanata-normal
```

---

## Learning Progression

1. **Day 1:** Get comfortable with thumb positions (Esc, Space, Enter, Backspace)
2. **Day 2:** Practice layer switches (hold Space for numbers, hold Enter for symbols)
3. **Day 3:** Learn homerow mods (D/L for Shift)
4. **Day 4:** Master navigation (hold Space + JKLN,M.;)
5. **Day 5:** Practice symbol typing (hold Enter + homerow)
6. **Week 2:** Build muscle memory for all layers

---

## Files

- **Config:** `~/.config/kanata/kanata-32key-experimental.kbd`
- **Current active:** `~/.config/kanata/kanata.kbd` (symlinked from dotfiles)
- **Backup:** `~/.config/kanata/kanata.kbd.backup` (auto-created)
- **Logs:** `/tmp/kanata.err.log`

---

## Next Steps / TODOs

- [ ] Test physical right-hand shift mapping (does L→J work?)
- [ ] Adjust homerow mod timing if too sensitive
- [ ] Consider if you need a Function layer (F1-F12)
- [ ] Evaluate if Alt/Cmd positions feel natural
- [ ] Add more navigation shortcuts if needed
- [ ] Document any issues or desired changes

---

## References

- Miryoku layout: https://github.com/manna-harbour/miryoku
- Kanata docs: https://github.com/jtroo/kanata
- Config guide: https://github.com/jtroo/kanata/blob/main/docs/config.adoc

using InteractBase
using CSSUtil
using InteractBulma, Blink
using WebIO
w = Window()

#---
f = filepicker();
body!(w, f)
observe(f)
#---

f = filepicker(multiple = true, accept = ".csv");
display(f)
observe(f)
#---

s = autocomplete(["Opt 1", "Option 2", "Opt 3"])
body!(w, s)
#---
s = InteractBase.input(typ="color")
body!(w, s)
#---
s1 = slider(1:20)
sobs = observe(s1)
body!(w, vbox(s1, sobs));
#---
button1 = button("button one {{clicks}}")
num_clicks = observe(button1)
button2 = button("button two {{clicks}}", clicks = num_clicks)
body!(w, hbox(button1, button2, num_clicks));
#---
using WebIO, Blink, Observables

width, height = 700, 300
colors = ["black", "gray", "silver", "maroon", "red", "olive", "yellow", "green", "lime", "teal", "aqua", "navy", "blue", "purple", "fuchsia"]
color(i) = colors[i%length(colors)+1]
ui = @manipulate for nsamples in 1:200,
        sample_step in slider(0.01:0.01:1.0, value=0.1, label="sample step"),
        phase in slider(0:0.1:2pi, value=0.0, label="phase"),
        radii in 0.1:0.1:60
    cxs_unscaled = [i*sample_step + phase for i in 1:nsamples]
    cys = sin.(cxs_unscaled) .* height/3 .+ height/2
    cxs = cxs_unscaled .* width/4pi
    dom"svg:svg[width=$width, height=$height]"(
        (dom"svg:circle[cx=$(cxs[i]), cy=$(cys[i]), r=$radii, fill=$(color(i))]"()
            for i in 1:nsamples)...
    )
end
body!(w, ui)
#---

using InteractBase, Plots, CSSUtil, DataStructures

x = y = 0:0.1:30

freqs = OrderedDict(zip(["pi/4", "π/2", "3π/4", "π"], [π/4, π/2, 3π/4, π]))

mp = @manipulate for freq1 in freqs, freq2 in slider(0.01:0.1:4π; label="freq2")
    y = @. sin(freq1*x) * sin(freq2*x)
    plot(x, y)
end
body!(w, mp)

#---
s = dropdown(["a1", "a2nt", "a3"], label = "test")
body!(w, s)
observe(s)
#---

s = togglebuttons(["a1", "a2nt", "a3"], label = "x");
body!(w, s)
observe(s)
#---

s = radiobuttons(["a1", "a2nt", "a3"]);
display(s)
#---
# IJulia
ui = s
display(ui);
# Mux
using Mux
webio_serve(page("/", req -> ui))
#---
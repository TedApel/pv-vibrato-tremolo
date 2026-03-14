# Vibrato and Tremolo Preservation during Phase Vocoder Time-Stretching

Ted Apel
Victoria University of Wellington

[Project page with sound examples](https://vud.org/projects/vibratotremolo/)

## About

This work addresses the loss of vibrato and tremolo that occurs during phase vocoder time-stretching. When a phase vocoder time-stretches a sound with vibrato or tremolo, the rate of modulation is slowed along with the sound, changing the character of the original performance. This work presents a method for preserving these sub-audio modulations during time-stretching by using a second spectral analysis to identify and extract them before stretching, and then re-imposing them at their original rate afterward.

The method performs a second-order spectral analysis (2DFT) on the time-varying magnitude and frequency trajectories of the first-order phase vocoder analysis. Modulation components are identified as peaks in this second-order spectrum, removed prior to time-stretching, and re-imposed on the stretched signal at their original modulation rate.

[Paper (PDF)](paper/vibratotremolo.pdf)

## Sound Examples

### Sine Wave with Amplitude Modulation (Tremolo)
- `sine_amp_mod.wav` — Original AM signal
- `sine_amp_mod_removed.wav` — Modulation removed
- `sine_amp_mod_removed_long.wav` — Time-stretched with modulation removed
- `sine_amp_mod_addedback2.wav` — Modulation re-imposed after stretching

### Sine Wave with Frequency Modulation (Vibrato)
- `sine_freq_mod.wav` — Original FM signal
- `sine_freq_mod_removed.wav` — Modulation removed
- `sine_freq_mod_removed_long.wav` — Time-stretched with modulation removed
- `sine_freq_mod_addback30.wav` — Modulation re-imposed after stretching

### Saxophone
- `sax.wav` — Original
- `sax_traditional_pv.wav` — Traditional phase vocoder stretch
- `sax_mod_removed.wav` — Modulation removed
- `sax_mod_removed_long.wav` — Time-stretched with modulation removed
- `sax_mod_addedback.wav` — Modulation re-imposed after stretching
- `sax_mod_addedback2.wav` — Modulation re-imposed (variant)

### Violin
- `violin.wav` — Original
- `violin_a3.wav` — Original A3
- `violin_traditional_pv.wav` — Traditional phase vocoder stretch
- `violin_mod_removed.wav` — Modulation removed
- `violin_mod_removed_long.wav` — Time-stretched with modulation removed
- `violin_mod_addedback.wav` — Modulation re-imposed after stretching

### Flute
- `flute.wav` — Original
- `flute_traditional_pv.wav` — Traditional phase vocoder stretch
- `flute_mod_removed.wav` — Modulation removed
- `flute_mod_removed_long.wav` — Time-stretched with modulation removed
- `flute_mod_addedback.wav` — Modulation re-imposed after stretching

## Code

The `octave/` directory contains GNU Octave implementations of the vibrato and tremolo preservation algorithm. Key files:

- `fppv_phaseVocoder_Player.m` — Main script demonstrating the full pipeline
- `fppv_phaseVocoder_FM_long.m` — Main script for FM analysis
- `fppv_time_stretch.m` — Standard phase vocoder time-stretch
- `fppv_stretch_phase_only.m` — Phase-only stretching
- `fppv_phase_vocoder_second_long.m` — Phase vocoder with second-order analysis
- `fppv_second_analysis_long.m` — Second-order spectral analysis (modulation extraction)
- `fppv_second_analysis_addmod.m` — Re-imposition of modulation after stretching
- `fppv_phase_vocoder_second_addmod.m` — Synthesis with modulation re-imposed
- `fppv_first_order_stretch.m` — First-order time-stretching
- `fppv_second_order_stretch.m` — Second-order time-stretching
- `princarg.m` — Principal argument function

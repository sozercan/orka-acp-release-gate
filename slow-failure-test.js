// Stay active beyond Orka's unchanged 45-minute repository-validation deadline.
// A 60-minute natural exit bounds the fixture if deadline enforcement fails.
setTimeout(() => { process.exitCode = 0; }, 3600000);

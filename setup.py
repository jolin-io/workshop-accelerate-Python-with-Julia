import setuptools
# from setuptools.extension import Extension
from Cython.Build import cythonize
import Cython

setuptools.setup(
    # Cython
    ext_modules = cythonize("agent.pyx"),

    # setup_requires=[
    #     'cython>=0.x',
    # ],
    # extensions = [Extension("*", ["*.pyx"])],

    # cmdclass={'build_ext': Cython.Build.build_ext},

    # Pluto
    name="jupyter-pluto-proxy",
    # py_modules rather than packages, since we only have 1 file
    py_modules=['plutoserver'],
    entry_points={
        'jupyter_serverproxy_servers': [
            # name = packagename:function_name
            'pluto = plutoserver:setup_plutoserver',
        ]
    },
    install_requires=[
        'jupyter-server-proxy @ git+http://github.com/fonsp/jupyter-server-proxy@3a58aa5005f942d0c208eab9a480f6ab171142ef',
    ],
    zip_safe=False,
)
